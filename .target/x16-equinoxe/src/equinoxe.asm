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
  .label BLUE = 6
  .label YELLOW = 7
  .label PINK = $a
  .label GREY = $c
  .label LIGHT_BLUE = $e
  ///< Close a logical file.
  .label CBM_CLRCHN = $ffcc
  ///< CX16 Set/Get screen mode.
  .label CX16_SCREEN_SET_CHARSET = $ff62
  .label VERA_DCSEL = 2
  .label VERA_VSYNC = 1
  .label VERA_SPRITES_ENABLE = $40
  .label VERA_LAYER1_ENABLE = $20
  .label VERA_LAYER0_ENABLE = $10
  .label STAGE_ACTION_MOVE = 2
  .label STAGE_ACTION_TURN = 3
  .label STAGE_ACTION_END = $ff
  // CX16 CBM Mouse Routines
  .label CX16_MOUSE_CONFIG = $ff68
  // ISR routine to scan the mouse state.
  .label CX16_MOUSE_GET = $ff6b
  .label OFFSET_STRUCT_FLIGHT_T_XF = $280
  .label OFFSET_STRUCT_FLIGHT_T_YF = $2c0
  .label OFFSET_STRUCT_FLIGHT_T_XI = $300
  .label OFFSET_STRUCT_FLIGHT_T_YI = $380
  .label OFFSET_STRUCT_FLIGHT_T_XD = $400
  .label OFFSET_STRUCT_FLIGHT_T_YD = $480
  .label SIZEOF_STRUCT_STAGE_T = $38
  .label SIZEOF_STRUCT_STAGE_PLAYBOOK_T = $a
  .label SIZEOF_STRUCT_COLLISION_DECISION_T = $a
  .label OFFSET_STRUCT_CX16_MOUSE_T_WAIT = 9
  .label OFFSET_STRUCT_CX16_MOUSE_T_Y = 2
  .label OFFSET_STRUCT_CX16_MOUSE_T_STATUS = 8
  .label OFFSET_STRUCT_CX16_MOUSE_T_PX = 4
  .label OFFSET_STRUCT_CX16_MOUSE_T_PY = 6
  .label OFFSET_STRUCT_HT_ITEM_T_NEXT = $100
  .label OFFSET_STRUCT_HT_LIST_S_NEXT = $100
  .label OFFSET_STRUCT_FLIGHT_T_MOVED = $5c0
  .label OFFSET_STRUCT_FLIGHT_T_FIREGUN = $700
  .label OFFSET_STRUCT_FLIGHT_T_RELOAD = $740
  .label OFFSET_STRUCT_FLIGHT_T_HEALTH = $880
  .label OFFSET_STRUCT_FLIGHT_T_IMPACT = $8c0
  .label OFFSET_STRUCT_FLIGHT_T_ANIMATE = $900
  .label OFFSET_STRUCT_FLIGHT_T_ENGINE = $6c0
  .label OFFSET_STRUCT_STAGE_T_PLAYER = $10
  .label OFFSET_STRUCT_FLIGHT_T_USED = $c0
  .label OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN = $35
  .label OFFSET_STRUCT_FLIGHT_T_COLLIDED = $140
  .label OFFSET_STRUCT_FLIGHT_T_TYPE = $180
  .label OFFSET_STRUCT_FLIGHT_T_CX = $200
  .label OFFSET_STRUCT_FLIGHT_T_CY = $240
  .label OFFSET_STRUCT_FLIGHT_T_SIDE = $1c0
  .label OFFSET_STRUCT_COLLISION_DECISION_T_S = 1
  .label OFFSET_STRUCT_COLLISION_DECISION_T_X = 2
  .label OFFSET_STRUCT_COLLISION_DECISION_T_Y = 3
  .label OFFSET_STRUCT_COLLISION_DECISION_T_SIDE = 5
  .label OFFSET_STRUCT_COLLISION_DECISION_T_TYPE = 4
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN = $210
  .label OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X = 6
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN = $220
  .label OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y = 7
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX = $230
  .label OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X = 8
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX = $240
  .label OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y = 9
  .label OFFSET_STRUCT_STAGE_T_SCRIPT_B = $15
  .label OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B = 1
  .label OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT = $1a
  .label OFFSET_STRUCT_STAGE_T_LIVES = $34
  .label OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL = $1e
  .label OFFSET_STRUCT_STAGE_T_EW = $18
  .label OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT = $1c
  .label OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER = 3
  .label OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE = 1
  .label OFFSET_STRUCT_STAGE_WAVE_T_X = $30
  .label OFFSET_STRUCT_STAGE_WAVE_T_DX = $50
  .label OFFSET_STRUCT_STAGE_WAVE_T_Y = $40
  .label OFFSET_STRUCT_STAGE_WAVE_T_DY = $58
  .label OFFSET_STRUCT_STAGE_WAVE_T_INTERVAL = $60
  .label OFFSET_STRUCT_STAGE_WAVE_T_WAIT = $68
  .label OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN = 8
  .label OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE = $28
  .label OFFSET_STRUCT_STAGE_T_ENEMY_COUNT = $13
  .label OFFSET_STRUCT_STAGE_WAVE_T_USED = $78
  .label OFFSET_STRUCT_STAGE_WAVE_T_FINISHED = $80
  .label OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPRITE = $10
  .label OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO = $88
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_PREV = $e
  .label OFFSET_STRUCT_STAGE_T_BULLET_COUNT = $11
  .label OFFSET_STRUCT_STAGE_FLIGHTPATH_T_TYPE = 4
  .label OFFSET_STRUCT_STAGE_FLIGHTPATH_T_NEXT = 5
  .label OFFSET_STRUCT_STAGE_ACTION_MOVE_T_TURN = 2
  .label OFFSET_STRUCT_STAGE_ACTION_MOVE_T_SPEED = 3
  .label OFFSET_STRUCT_STAGE_ACTION_TURN_T_RADIUS = 1
  .label OFFSET_STRUCT_STAGE_ACTION_TURN_T_SPEED = 2
  .label OFFSET_STRUCT_FLIGHT_T_SPEED = $7c0
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT = $20
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP = $f0
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE = $d0
  .label OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B = 1
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_X = 6
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_Y = 8
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_DX = $a
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_DY = $b
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_FLIGHTPATH = 4
  .label OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_FLIGHTPATH = $18
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_SPAWN = 1
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY = 2
  .label OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_SPEED = 4
  .label OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_SPEED = $98
  .label OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_REVERSE = 5
  .label OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_REVERSE = $a0
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_INTERVAL = $c
  .label OFFSET_STRUCT_STAGE_WAVE_T_PREV = $70
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_WAIT = $d
  .label OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET = $25
  .label OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET = 3
  .label OFFSET_STRUCT_STAGE_ENEMY_T_STAGE_BULLET = 2
  .label OFFSET_STRUCT_STAGE_T_PLAYER_COUNT = $12
  .label OFFSET_STRUCT_FLIGHT_T_WAVE = $a01
  .label OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH = $980
  .label OFFSET_STRUCT_FLIGHT_T_MOVING = $600
  .label OFFSET_STRUCT_FLIGHT_T_ACTION = $940
  .label OFFSET_STRUCT_FLIGHT_T_MOVE = $580
  .label OFFSET_STRUCT_FLIGHT_T_ANGLE = $780
  .label OFFSET_STRUCT_FLIGHT_T_DELAY = $680
  .label OFFSET_STRUCT_FLIGHT_T_TURN = $800
  .label OFFSET_STRUCT_FLIGHT_T_RADIUS = $840
  .label OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC = 1
  .label OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE = 2
  .label SIZEOF_STRUCT_STAGE_SCENARIO_T = $10
  .label SIZEOF_STRUCT_CX16_MOUSE_T = $a
  .label SIZEOF_STRUCT_HT_LIST_S = $200
  .label SIZEOF_STRUCT_AABB_T = 4
  .label SIZEOF_STRUCT_FLOOR_SEGMENT_T = 5
  .label SIZEOF_STRUCT_FLOOR_COMPOSITION_T = $c
  .label SIZEOF_STRUCT_HT_ITEM_T = $200
  .label SIZEOF_STRUCT_COLLISION_QUADRANT_T = $100
  .label SIZEOF_STRUCT_STAGE_WAVE_T = $a8
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
    // [126] phi from __start::@1 to __lib_conio_start [phi:__start::@1->__lib_conio_start]
    jsr lib_conio.__lib_conio_start
    // [6] phi from __start::@1 to __start::@2 [phi:__start::@1->__start::@2]
    // __start::@2
    // [7] call __equinoxe_flightengine_start
    // [128] phi from __start::@2 to __equinoxe_flightengine_start [phi:__start::@2->__equinoxe_flightengine_start]
    jsr equinoxe_flightengine.__equinoxe_flightengine_start
    // [8] phi from __start::@2 to __start::@3 [phi:__start::@2->__start::@3]
    // __start::@3
    // [9] call __lib_file_start
    // [130] phi from __start::@3 to __lib_file_start [phi:__start::@3->__lib_file_start]
    jsr lib_file.__lib_file_start
    // [10] phi from __start::@3 to __start::@4 [phi:__start::@3->__start::@4]
    // __start::@4
    // [11] call __lib_lru_cache_start
    // [132] phi from __start::@4 to __lib_lru_cache_start [phi:__start::@4->__lib_lru_cache_start]
    jsr lib_lru_cache.__lib_lru_cache_start
    // [12] phi from __start::@4 to __start::@5 [phi:__start::@4->__start::@5]
    // __start::@5
    // [13] call __lib_bramheap_start
    // [134] phi from __start::@5 to __lib_bramheap_start [phi:__start::@5->__lib_bramheap_start]
    jsr lib_bramheap.__lib_bramheap_start
    // [14] phi from __start::@5 to __start::@6 [phi:__start::@5->__start::@6]
    // __start::@6
    // [15] call __lib_veraheap_start
    // [136] phi from __start::@6 to __lib_veraheap_start [phi:__start::@6->__lib_veraheap_start]
    jsr lib_veraheap.__lib_veraheap_start
    // [16] phi from __start::@6 to __start::@7 [phi:__start::@6->__start::@7]
    // __start::@7
    // [17] call __equinoxe_palette_start
    // [138] phi from __start::@7 to __equinoxe_palette_start [phi:__start::@7->__equinoxe_palette_start]
    jsr equinoxe_palette.__equinoxe_palette_start
    // [18] phi from __start::@7 to __start::@8 [phi:__start::@7->__start::@8]
    // __start::@8
    // [19] call __equinoxe_animate_start
    // [140] phi from __start::@8 to __equinoxe_animate_start [phi:__start::@8->__equinoxe_animate_start]
    jsr equinoxe_animate.__equinoxe_animate_start
    // [20] phi from __start::@8 to __start::@9 [phi:__start::@8->__start::@9]
    // __start::@9
    // [21] call __cx16_file_start
    // [142] phi from __start::@9 to __cx16_file_start [phi:__start::@9->__cx16_file_start]
    jsr cx16_file.__cx16_file_start
    // [22] phi from __start::@9 to __start::@10 [phi:__start::@9->__start::@10]
    // __start::@10
    // [23] call __equinoxe_layers_start
    // [144] phi from __start::@10 to __equinoxe_layers_start [phi:__start::@10->__equinoxe_layers_start]
    jsr equinoxe_layers.__equinoxe_layers_start
    // [24] phi from __start::@10 to __start::@11 [phi:__start::@10->__start::@11]
    // __start::@11
    // [25] call main
    jsr main
    // __start::@return
    // [26] return 
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
    // [28] BROM = irq_vsync::bank_set_brom1_bank#0 -- vbuz1=vbuc1 
    lda #bank_set_brom1_bank
    sta.z BROM
    // irq_vsync::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [29] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [30] *VERA_DC_BORDER = YELLOW -- _deref_pbuc1=vbuc2 
    lda #YELLOW
    sta VERA_DC_BORDER
    // irq_vsync::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [32] BRAM = irq_vsync::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // irq_vsync::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [33] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [34] *VERA_DC_BORDER = BLUE -- _deref_pbuc1=vbuc2 
    lda #BLUE
    sta VERA_DC_BORDER
    // [35] phi from irq_vsync::vera_display_set_border_color2 to irq_vsync::@3 [phi:irq_vsync::vera_display_set_border_color2->irq_vsync::@3]
    // irq_vsync::@3
    // collision_init()
    // [36] call collision_init
    // [229] phi from irq_vsync::@3 to collision_init [phi:irq_vsync::@3->collision_init]
    jsr collision_init
    // [37] phi from irq_vsync::@3 to irq_vsync::@9 [phi:irq_vsync::@3->irq_vsync::@9]
    // irq_vsync::@9
    // cx16_mouse_get()
    // [38] call cx16_mouse_get
    // cx16_mouse_scan(); 
    jsr cx16_mouse_get
    // irq_vsync::@10
    // unsigned char tickupdate = game.ticksync & 0x01
    // [39] irq_vsync::tickupdate#0 = *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC) & 1 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #1
    and game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC
    // if(!tickupdate)
    // [40] if(0!=irq_vsync::tickupdate#0) goto irq_vsync::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // irq_vsync::@2
    // stage_logic(game.tickstage)
    // [41] stage_logic::tickstage#0 = *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE) -- vbuxx=_deref_pbuc1 
    ldx game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE
    // [42] call stage_logic
    // [251] phi from irq_vsync::@2 to stage_logic [phi:irq_vsync::@2->stage_logic]
    // [251] phi stage_logic::tickstage#2 = stage_logic::tickstage#0 [phi:irq_vsync::@2->stage_logic#0] -- call_phi_close_cx16_ram 
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
    // irq_vsync::@11
    // game.tickstage++;
    // [43] *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE) = ++ *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE
    // irq_vsync::@1
  __b1:
    // game.ticksync++;
    // [44] *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC) = ++ *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC
    // irq_vsync::vera_display_set_border_color3
    // *VERA_CTRL &= 0b10000001
    // [45] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [46] *VERA_DC_BORDER = LIGHT_BLUE -- _deref_pbuc1=vbuc2 
    lda #LIGHT_BLUE
    sta VERA_DC_BORDER
    // [47] phi from irq_vsync::vera_display_set_border_color3 to irq_vsync::@4 [phi:irq_vsync::vera_display_set_border_color3->irq_vsync::@4]
    // irq_vsync::@4
    // player_logic()
    // [48] call player_logic -- call_phi_close_cx16_ram 
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
    // [49] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [50] *VERA_DC_BORDER = YELLOW -- _deref_pbuc1=vbuc2 
    lda #YELLOW
    sta VERA_DC_BORDER
    // [51] phi from irq_vsync::vera_display_set_border_color4 to irq_vsync::@5 [phi:irq_vsync::vera_display_set_border_color4->irq_vsync::@5]
    // irq_vsync::@5
    // bullet_logic()
    // [52] call bullet_logic -- call_phi_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #7
    sta.z 0
    lda.z $ff
    jsr bullet_logic
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // irq_vsync::vera_display_set_border_color5
    // *VERA_CTRL &= 0b10000001
    // [53] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [54] *VERA_DC_BORDER = PINK -- _deref_pbuc1=vbuc2 
    lda #PINK
    sta VERA_DC_BORDER
    // [55] phi from irq_vsync::vera_display_set_border_color5 to irq_vsync::@6 [phi:irq_vsync::vera_display_set_border_color5->irq_vsync::@6]
    // irq_vsync::@6
    // enemy_logic()
    // [56] call enemy_logic -- call_phi_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #8
    sta.z 0
    lda.z $ff
    jsr enemy_logic
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // irq_vsync::vera_display_set_border_color6
    // *VERA_CTRL &= 0b10000001
    // [57] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [58] *VERA_DC_BORDER = WHITE -- _deref_pbuc1=vbuc2 
    lda #WHITE
    sta VERA_DC_BORDER
    // [59] phi from irq_vsync::vera_display_set_border_color6 to irq_vsync::@7 [phi:irq_vsync::vera_display_set_border_color6->irq_vsync::@7]
    // irq_vsync::@7
    // collision_detect()
    // [60] call collision_detect
    // [531] phi from irq_vsync::@7 to collision_detect [phi:irq_vsync::@7->collision_detect]
    jsr collision_detect
    // irq_vsync::vera_display_set_border_color7
    // *VERA_CTRL &= 0b10000001
    // [61] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [62] *VERA_DC_BORDER = GREY -- _deref_pbuc1=vbuc2 
    lda #GREY
    sta VERA_DC_BORDER
    // [63] phi from irq_vsync::vera_display_set_border_color7 to irq_vsync::@8 [phi:irq_vsync::vera_display_set_border_color7->irq_vsync::@8]
    // irq_vsync::@8
    // flight_draw()
    // [64] callexecute flight_draw  -- call_var_near 
    jsr equinoxe_flightengine.flight_draw
    // *VERA_ISR = 1
    // [65] *VERA_ISR = 1 -- _deref_pbuc1=vbuc2 
    // Reset the VSYNC interrupt
    lda #1
    sta VERA_ISR
    // irq_vsync::bank_pull_bram1
    // asm
    // asm { pla sta$00  }
    pla
    sta.z 0
    // irq_vsync::vera_display_set_border_color8
    // *VERA_CTRL &= 0b10000001
    // [67] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [68] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // irq_vsync::@return
    // }
    // [69] return 
    // interrupt(isr_rom_sys_cx16_exit) -- isr_rom_sys_cx16_exit 
    jmp (isr_vsync)
}
  // cx16_irq_reset
// void cx16_irq_reset()
cx16_irq_reset: {
    // isr_vsync = *(IRQ_TYPE*)0x0314
    // [84] isr_vsync = *((void (**)()) 788) -- pprm1=_deref_qprc1 
    lda $314
    sta isr_vsync
    lda $314+1
    sta isr_vsync+1
    // cx16_irq_reset::@return
    // }
    // [85] return 
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
    .label cx16_k_screen_set_charset1_offset = $55
    // cx16_k_screen_set_charset(3, (char *)0)
    // [146] main::cx16_k_screen_set_charset1_charset = 3 -- vbum1=vbuc1 
    lda #3
    sta cx16_k_screen_set_charset1_charset
    // [147] main::cx16_k_screen_set_charset1_offset = (char *) 0 -- pbuz1=pbuc1 
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
    // [149] BROM = CX16_ROM_KERNAL -- vbuz1=vbuc1 
    lda #CX16_ROM_KERNAL
    sta.z BROM
    // main::vera_layer0_hide1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [150] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER0_ENABLE
    // [151] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER0_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [152] phi from main::vera_layer0_hide1 to main::@4 [phi:main::vera_layer0_hide1->main::@4]
    // main::@4
    // vera_layer1_hide()
    // [153] call vera_layer1_hide
    jsr vera_layer1_hide
    // [154] phi from main::@4 to main::@9 [phi:main::@4->main::@9]
    // main::@9
    // vera_petscii_init()
    // [155] callexecute vera_petscii_init  -- call_var_near 
    jsr equinoxe_layers.vera_petscii_init
    // scroll(1)
    // [156] scroll::onoff = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_conio.scroll.onoff
    // [157] callexecute scroll  -- call_var_near 
    jsr lib_conio.scroll
    // equinoxe_init()
    // [158] call equinoxe_init
  // music = fopen("music.bin","r");
    // [617] phi from main::@9 to equinoxe_init [phi:main::@9->equinoxe_init]
    jsr equinoxe_init
    // main::@10
    // bram_heap_bram_bank_init(BANK_HEAP_BRAM)
    // [159] bram_heap_bram_bank_init::bram_bank = $f -- vbum1=vbuc1 
    // We initialize the Commander X16 BRAM heap manager. This manages dynamically the memory space in banked ram as a real heap.
    lda #$f
    sta lib_bramheap.bram_heap_bram_bank_init.bram_bank
    // [160] callexecute bram_heap_bram_bank_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_bram_bank_init
    // bram_heap_segment_init(0, 0x10, (bram_ptr_t)0xA000, 0x3C, (bram_ptr_t)0xA000)
    // [161] bram_heap_segment_init::s = 0 -- vbum1=vbuc1 
    // BREAKPOINT
    lda #0
    sta lib_bramheap.bram_heap_segment_init.s
    // [162] bram_heap_segment_init::bram_bank_floor = $10 -- vbum1=vbuc1 
    lda #$10
    sta lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [163] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [164] bram_heap_segment_init::bram_bank_ceil = $3c -- vbum1=vbuc1 
    lda #$3c
    sta lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [165] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [166] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // bram_heap_segment_init(1, 0x3C, (bram_ptr_t)0xA000, 0x3F, (bram_ptr_t)0xA000)
    // [167] bram_heap_segment_init::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_bramheap.bram_heap_segment_init.s
    // [168] bram_heap_segment_init::bram_bank_floor = $3c -- vbum1=vbuc1 
    lda #$3c
    sta lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [169] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [170] bram_heap_segment_init::bram_bank_ceil = $3f -- vbum1=vbuc1 
    lda #$3f
    sta lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [171] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [172] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // vera_heap_bram_bank_init(BANK_VERA_HEAP)
    // [173] vera_heap_bram_bank_init::bram_bank = 1 -- vbum1=vbuc1 
    // We intialize the Commander X16 VERA heap manager. This manages dynamically the memory space in vera ram as a real heap.
    lda #1
    sta lib_veraheap.vera_heap_bram_bank_init.bram_bank
    // [174] callexecute vera_heap_bram_bank_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_bram_bank_init
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_TILES, FLOOR_TILE_BANK_VRAM, FLOOR_TILE_OFFSET_VRAM, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM)
    // [175] vera_heap_segment_init::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_veraheap.vera_heap_segment_init.s
    // [176] vera_heap_segment_init::vram_bank_floor = 0 -- vbum1=vbuc1 
    sta lib_veraheap.vera_heap_segment_init.vram_bank_floor
    // [177] vera_heap_segment_init::vram_offset_floor = 0 -- vwum1=vbuc1 
    sta lib_veraheap.vera_heap_segment_init.vram_offset_floor
    sta lib_veraheap.vera_heap_segment_init.vram_offset_floor+1
    // [178] vera_heap_segment_init::vram_bank_ceil = 0 -- vbum1=vbuc1 
    sta lib_veraheap.vera_heap_segment_init.vram_bank_ceil
    // [179] vera_heap_segment_init::vram_offset_ceil = $5000 -- vwum1=vwuc1 
    lda #<$5000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_ceil
    lda #>$5000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_ceil+1
    // [180] callexecute vera_heap_segment_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_segment_init
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_SPRITES, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM, FLOOR_MAP1_BANK_VRAM, FLOOR_MAP1_OFFSET_VRAM)
    // [181] vera_heap_segment_init::s = 1 -- vbum1=vbuc1 
    // FLOOR_TILE segment for tiles of various sizes and types
    lda #1
    sta lib_veraheap.vera_heap_segment_init.s
    // [182] vera_heap_segment_init::vram_bank_floor = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_veraheap.vera_heap_segment_init.vram_bank_floor
    // [183] vera_heap_segment_init::vram_offset_floor = $5000 -- vwum1=vwuc1 
    lda #<$5000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_floor
    lda #>$5000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_floor+1
    // [184] vera_heap_segment_init::vram_bank_ceil = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_veraheap.vera_heap_segment_init.vram_bank_ceil
    // [185] vera_heap_segment_init::vram_offset_ceil = $d000 -- vwum1=vwuc1 
    lda #<$d000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_ceil
    lda #>$d000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_ceil+1
    // [186] callexecute vera_heap_segment_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_segment_init
    // stage_reset()
    // [187] call stage_reset -- call_phi_close_cx16_ram 
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
    // [188] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTART = start
    // [189] *VERA_DC_HSTART = main::vera_display_set_hstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstart1_start
    sta VERA_DC_HSTART
    // main::vera_display_set_hstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [190] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTOP = stop
    // [191] *VERA_DC_HSTOP = main::vera_display_set_hstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstop1_stop
    sta VERA_DC_HSTOP
    // main::vera_display_set_vstart1
    // *VERA_CTRL |= VERA_DCSEL
    // [192] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTART = start
    // [193] *VERA_DC_VSTART = main::vera_display_set_vstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstart1_start
    sta VERA_DC_VSTART
    // main::vera_display_set_vstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [194] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTOP = stop
    // [195] *VERA_DC_VSTOP = main::vera_display_set_vstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstop1_stop
    sta VERA_DC_VSTOP
    // [196] phi from main::vera_display_set_vstop1 to main::@5 [phi:main::vera_display_set_vstop1->main::@5]
    // main::@5
    // stage_logic(0)
    // [197] call stage_logic
    // [251] phi from main::@5 to stage_logic [phi:main::@5->stage_logic]
    // [251] phi stage_logic::tickstage#2 = 0 [phi:main::@5->stage_logic#0] -- call_phi_close_cx16_ram 
    ldx #0
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
    // main::@11
    // scroll(0)
    // [198] scroll::onoff = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_conio.scroll.onoff
    // [199] callexecute scroll  -- call_var_near 
    jsr lib_conio.scroll
    // main::cbm_k_clrchn1
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // [201] phi from main::@1 main::cbm_k_clrchn1 to main::@1 [phi:main::@1/main::cbm_k_clrchn1->main::@1]
    // main::@1
  __b1:
    // kbhit()
    // [202] callexecute kbhit  -- call_var_near 
    jsr lib_conio.kbhit
    // [203] main::$29 = kbhit::return -- vbuaa=vbum1 
    lda lib_conio.kbhit.return
    // while(!kbhit())
    // [204] if(0==main::$29) goto main::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b1
    // main::SEI1
    // asm
    // asm { sei  }
    sei
    // [206] phi from main::SEI1 to main::@6 [phi:main::SEI1->main::@6]
    // main::@6
    // cx16_irq_relay(&irq_vsync)
    // [207] call cx16_irq_relay
    jsr cx16_irq_relay
    // main::@12
    // *VERA_IEN = VERA_VSYNC | 0x80
    // [208] *VERA_IEN = VERA_VSYNC|$80 -- _deref_pbuc1=vbuc2 
    // *KERNEL_IRQ = &irq_vsync;
    lda #VERA_VSYNC|$80
    sta VERA_IEN
    // *VERA_IRQLINE_L = 0xFF
    // [209] *VERA_IRQLINE_L = $ff -- _deref_pbuc1=vbuc2 
    lda #$ff
    sta VERA_IRQLINE_L
    // main::CLI1
    // asm
    // asm { cli  }
    cli
    // main::@7
    // cx16_mouse_config(0xFF, 80, 60)
    // [211] cx16_mouse_config::visible = $ff -- vbum1=vbuc1 
    sta cx16_mouse_config.visible
    // [212] cx16_mouse_config::scalex = $50 -- vbum1=vbuc1 
    lda #$50
    sta cx16_mouse_config.scalex
    // [213] cx16_mouse_config::scaley = $3c -- vbum1=vbuc1 
    lda #$3c
    sta cx16_mouse_config.scaley
    // [214] call cx16_mouse_config
    jsr cx16_mouse_config
    // [215] phi from main::@7 to main::@13 [phi:main::@7->main::@13]
    // main::@13
    // cx16_mouse_get()
    // [216] call cx16_mouse_get
    jsr cx16_mouse_get
    // main::vera_sprites_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [217] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    // [218] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_SPRITES_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [219] phi from main::vera_sprites_show1 to main::@8 [phi:main::vera_sprites_show1->main::@8]
    // main::@8
    // volatile unsigned char ch = kbhit()
    // [220] callexecute kbhit  -- call_var_near 
    jsr lib_conio.kbhit
    // [221] main::ch = kbhit::return -- vbum1=vbum2 
    lda lib_conio.kbhit.return
    sta ch
    // main::@2
  __b2:
    // while (ch != 'x')
    // [222] if(main::ch!='x'pm) goto main::@3 -- vbum1_neq_vbuc1_then_la1 
  .encoding "petscii_mixed"
    lda #'x'
    cmp ch
    bne __b3
    // main::bank_set_brom2
    // BROM = bank
    // [223] BROM = CX16_ROM_BASIC -- vbuz1=vbuc1 
    lda #CX16_ROM_BASIC
    sta.z BROM
    // main::@return
    // }
    // [224] return 
    rts
    // [225] phi from main::@2 to main::@3 [phi:main::@2->main::@3]
    // main::@3
  __b3:
    // kbhit()
    // [226] callexecute kbhit  -- call_var_near 
    jsr lib_conio.kbhit
    // [227] main::$32 = kbhit::return -- vbuaa=vbum1 
    lda lib_conio.kbhit.return
    // ch=kbhit()
    // [228] main::ch = main::$32 -- vbum1=vbuaa 
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
    .const memset_fast1_ch = 0
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast1_destination = collision_quadrant
    // ht_init(&collision_hash)
    // [230] call ht_init
    // [665] phi from collision_init to ht_init [phi:collision_init->ht_init]
    jsr ht_init
    // [231] phi from collision_init to collision_init::memset_fast1 [phi:collision_init->collision_init::memset_fast1]
    // collision_init::memset_fast1
    // [232] phi from collision_init::memset_fast1 to collision_init::memset_fast1_@1 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1]
    // [232] phi collision_init::memset_fast1_num#2 = 0 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [232] phi collision_init::memset_fast1_x#2 = 0 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [232] phi from collision_init::memset_fast1_@1 to collision_init::memset_fast1_@1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1]
    // [232] phi collision_init::memset_fast1_num#2 = collision_init::memset_fast1_num#1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1#0] -- register_copy 
    // [232] phi collision_init::memset_fast1_x#2 = collision_init::memset_fast1_x#1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1#1] -- register_copy 
    // collision_init::memset_fast1_@1
  memset_fast1___b1:
    // destination[x] = ch
    // [233] collision_init::memset_fast1_destination#0[collision_init::memset_fast1_x#2] = collision_init::memset_fast1_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast1_ch
    sta memset_fast1_destination,y
    // x++;
    // [234] collision_init::memset_fast1_x#1 = ++ collision_init::memset_fast1_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [235] collision_init::memset_fast1_num#1 = -- collision_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [236] if(0!=collision_init::memset_fast1_num#1) goto collision_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // collision_init::@return
    // }
    // [237] return 
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
 *
 * The mouse logic administers a previous x and y positions,
 * which have an update rate of every 4 enquiries.
 */
// char cx16_mouse_get()
cx16_mouse_get: {
    .label x = $fc
    .label y = $fe
    // __mem char status
    // [238] cx16_mouse_get::status = 0 -- vbum1=vbuc1 
    lda #0
    sta status
    // __address(0xfc) unsigned int x
    // [239] cx16_mouse_get::x = 0 -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // __address(0xfe) unsigned int y
    // [240] cx16_mouse_get::y = 0 -- vwuz1=vwuc1 
    sta.z y
    sta.z y+1
    // if(!cx16_mouse.wait)
    // [241] if(0!=*((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT)) goto cx16_mouse_get::@1 -- 0_neq__deref_pbuc1_then_la1 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT
    bne __b1
    // cx16_mouse_get::@2
    // cx16_mouse.px = cx16_mouse.x
    // [242] *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX) = *((unsigned int *)&cx16_mouse) -- _deref_pwuc1=_deref_pwuc2 
    lda cx16_mouse
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX
    lda cx16_mouse+1
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX+1
    // cx16_mouse.py = cx16_mouse.y
    // [243] *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PY) = *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y) -- _deref_pwuc1=_deref_pwuc2 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PY
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y+1
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PY+1
    // cx16_mouse.wait = 4
    // [244] *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT) = 4 -- _deref_pbuc1=vbuc2 
    lda #4
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT
    // cx16_mouse_get::@1
  __b1:
    // cx16_mouse.wait--;
    // [245] *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT) = -- *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT
    // asm
    // asm { ldx#$fc jsrCX16_MOUSE_GET stastatus  }
    ldx #$fc
    jsr CX16_MOUSE_GET
    sta status
    // cx16_mouse.x = x
    // [247] *((unsigned int *)&cx16_mouse) = cx16_mouse_get::x -- _deref_pwuc1=vwuz1 
    lda.z x
    sta cx16_mouse
    lda.z x+1
    sta cx16_mouse+1
    // cx16_mouse.y = y
    // [248] *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y) = cx16_mouse_get::y -- _deref_pwuc1=vwuz1 
    lda.z y
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y
    lda.z y+1
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y+1
    // cx16_mouse.status = status
    // [249] *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS) = cx16_mouse_get::status -- _deref_pbuc1=vbum1 
    lda status
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS
    // cx16_mouse_get::@return
    // }
    // [250] return 
    rts
  .segment Data
    status: .byte 0
}
.segment CodeEngineStages
  // stage_logic
// void stage_logic(__register(X) char tickstage)
// __bank(cx16_ram, 3) 
stage_logic: {
    .label stage_playbook_ptr1_stage_playbooks_b = $3b
    .label stage_playbook_ptr1_return = $3f
    .label stage_scenario_ptr1_stage_scenarios_b = $3b
    .label stage_scenario_ptr1_return = $3f
    .label stage_playbook_ptr2_stage_playbooks_b = $3b
    .label stage_playbook_ptr2_return = $3f
    .label stage_player_ptr_b = $3b
    .label stage_engine_ptr_b = $4f
    // if(stage.playbook_current < stage.script_b.playbook_total_b)
    // [252] if(*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT)>=*((char *)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B)) goto stage_logic::@1 -- _deref_pwuc1_ge__deref_pbuc2_then_la1 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    bne __b1
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    cmp stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B
    bcs __b1
  !:
    // stage_logic::@2
    // tickstage & 0x03
    // [253] stage_logic::$3 = stage_logic::tickstage#2 & 3 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #3
    // if(!(tickstage & 0x03))
    // [254] if(0!=stage_logic::$3) goto stage_logic::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // [255] phi from stage_logic::@2 to stage_logic::@4 [phi:stage_logic::@2->stage_logic::@4]
    // [255] phi stage_logic::w#10 = 0 [phi:stage_logic::@2->stage_logic::@4#0] -- vbum1=vbuc1 
    lda #0
    sta w
  // BREAKPOINT
    // stage_logic::@4
  __b4:
    // for(__mem unsigned char w=0; w<8; w++)
    // [256] if(stage_logic::w#10<8) goto stage_logic::@5 -- vbum1_lt_vbuc1_then_la1 
    lda w
    cmp #8
    bcs !__b5+
    jmp __b5
  !__b5:
    // [257] phi from stage_logic::@4 to stage_logic::@14 [phi:stage_logic::@4->stage_logic::@14]
    // [257] phi stage_logic::w1#2 = 0 [phi:stage_logic::@4->stage_logic::@14#0] -- vbum1=vbuc1 
    lda #0
    sta w1
    // stage_logic::@14
  __b14:
    // for(unsigned char w=0; w<8; w++)
    // [258] if(stage_logic::w1#2<8) goto stage_logic::@15 -- vbum1_lt_vbuc1_then_la1 
    lda w1
    cmp #8
    bcs !__b15+
    jmp __b15
  !__b15:
    // stage_logic::@16
    // if(stage.scenario_current >= stage.scenario_total)
    // [259] if(*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT)<*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL)) goto stage_logic::@1 -- _deref_pwuc1_lt__deref_pwuc2_then_la1 
    lda stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT+1
    cmp stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL+1
    bcc __b1
    bne !+
    lda stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT
    cmp stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL
    bcc __b1
  !:
    // stage_logic::@23
    // if(stage.playbook_current < stage.script_b.playbook_total_b)
    // [260] if(*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT)>=*((char *)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B)) goto stage_logic::@1 -- _deref_pwuc1_ge__deref_pbuc2_then_la1 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    bne __b1
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    cmp stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B
    bcs __b1
  !:
    // stage_logic::@24
    // stage.scenario_current = 0
    // [261] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT) = 0 -- _deref_pwuc1=vbuc2 
    // stage.playbook_current++;
    // stage_playbook_t* stage_playbook = stage.script_b.playbooks_b;
    // stage.current_playbook = stage_playbook[stage.playbook_current];
    // stage.scenario_total = stage.current_playbook.scenario_total_b;
    lda #<0
    sta stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT
    sta stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT+1
    // stage_logic::@1
  __b1:
    // if(stage.player_respawn)
    // [262] if(0==*((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN)) goto stage_logic::@return -- 0_eq__deref_pbuc1_then_la1 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN
    beq __breturn
    // stage_logic::@3
    // stage.player_respawn--;
    // [263] *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN) = -- *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN
    // if(!stage.player_respawn)
    // [264] if(0!=*((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN)) goto stage_logic::@return -- 0_neq__deref_pbuc1_then_la1 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN
    bne __breturn
    // stage_logic::stage_playbook_ptr2
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [265] stage_logic::stage_playbook_ptr2_stage_playbooks_b#0 = *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) -- pssz1=_deref_qssc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    sta.z stage_playbook_ptr2_stage_playbooks_b
    lda stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    sta.z stage_playbook_ptr2_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [266] stage_logic::$57 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_logic__57
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_logic__57+1
    asl stage_logic__57
    rol stage_logic__57+1
    // [267] stage_logic::$58 = stage_logic::$57 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_logic__58
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_logic__58
    lda stage_logic__58+1
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_logic__58+1
    // [268] stage_logic::stage_playbook_ptr2_$1 = stage_logic::$58 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr2_stage_logic__1
    rol stage_playbook_ptr2_stage_logic__1+1
    // [269] stage_logic::stage_playbook_ptr2_return#0 = stage_logic::stage_playbook_ptr2_stage_playbooks_b#0 + stage_logic::stage_playbook_ptr2_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr2_stage_logic__1
    clc
    adc.z stage_playbook_ptr2_stage_playbooks_b
    sta.z stage_playbook_ptr2_return
    lda stage_playbook_ptr2_stage_logic__1+1
    adc.z stage_playbook_ptr2_stage_playbooks_b+1
    sta.z stage_playbook_ptr2_return+1
    // stage_logic::@26
    // stage_player_t* stage_player_ptr_b = stage_playbook_ptr_b->stage_player
    // [270] stage_logic::stage_player_ptr_b#0 = ((stage_player_t **)stage_logic::stage_playbook_ptr2_return#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER
    lda (stage_playbook_ptr2_return),y
    sta.z stage_player_ptr_b
    iny
    lda (stage_playbook_ptr2_return),y
    sta.z stage_player_ptr_b+1
    // stage_engine_t* stage_engine_ptr_b = stage_player_ptr_b->stage_engine
    // [271] stage_logic::stage_engine_ptr_b#0 = ((stage_engine_t **)stage_logic::stage_player_ptr_b#0)[OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE
    lda (stage_player_ptr_b),y
    sta.z stage_engine_ptr_b
    iny
    lda (stage_player_ptr_b),y
    sta.z stage_engine_ptr_b+1
    // player_add(stage_player_ptr_b->player_sprite, stage_engine_ptr_b->engine_sprite)
    // [272] player_add::sprite_player#1 = *((char *)stage_logic::stage_player_ptr_b#0) -- vbuxx=_deref_pbuz1 
    ldy #0
    lda (stage_player_ptr_b),y
    tax
    // [273] player_add::sprite_engine#1 = *((char *)stage_logic::stage_engine_ptr_b#0) -- vbum1=_deref_pbuz2 
    lda (stage_engine_ptr_b),y
    sta player_add.sprite_engine
    // [274] call player_add
    // [680] phi from stage_logic::@26 to player_add [phi:stage_logic::@26->player_add]
    // [680] phi player_add::sprite_engine#2 = player_add::sprite_engine#1 [phi:stage_logic::@26->player_add#0] -- register_copy 
    // [680] phi player_add::sprite_player#2 = player_add::sprite_player#1 [phi:stage_logic::@26->player_add#1] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <player_add
    .byte >player_add
    .byte 9
    // stage_logic::@return
  __breturn:
    // }
    // [275] return 
    rts
    // stage_logic::@15
  __b15:
    // if(wave.finished[w])
    // [276] if(0==((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_FINISHED)[stage_logic::w1#2]) goto stage_logic::@17 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w1
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_FINISHED,y
    cmp #0
    beq __b17
    // stage_logic::@22
    // __mem stage_scenario_index_t new_scenario = wave.scenario[w]
    // [277] stage_logic::$34 = stage_logic::w1#2 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [278] stage_logic::new_scenario#0 = ((unsigned int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO)[stage_logic::$34] -- vwum1=pwuc1_derefidx_vbuxx 
    // If there are more scenarios, create new waves based on the scenarios dependent on the finished wave.
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO,x
    sta new_scenario
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO+1,x
    sta new_scenario+1
    // __mem unsigned int wave_scenario = wave.scenario[w]
    // [279] stage_logic::wave_scenario#0 = ((unsigned int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO)[stage_logic::$34] -- vwum1=pwuc1_derefidx_vbuxx 
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO,x
    sta wave_scenario
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO+1,x
    sta wave_scenario+1
    // [280] phi from stage_logic::@20 stage_logic::@22 to stage_logic::@18 [phi:stage_logic::@20/stage_logic::@22->stage_logic::@18]
  __b2:
    // [280] phi stage_logic::new_scenario#10 = stage_logic::new_scenario#1 [phi:stage_logic::@20/stage_logic::@22->stage_logic::@18#0] -- register_copy 
  // TODO find solution for this loop, maybe with pointers?
    // stage_logic::@18
    // while(new_scenario < stage.scenario_total)
    // [281] if(stage_logic::new_scenario#10<*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL)) goto stage_logic::stage_playbook_ptr1 -- vwum1_lt__deref_pwuc1_then_la1 
    lda new_scenario+1
    cmp stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL+1
    bcc stage_playbook_ptr1
    bne !+
    lda new_scenario
    cmp stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL
    bcc stage_playbook_ptr1
  !:
    // stage_logic::@19
    // wave.finished[w] = 0
    // [282] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_FINISHED)[stage_logic::w1#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy w1
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_FINISHED,y
    // stage_logic::@17
  __b17:
    // for(unsigned char w=0; w<8; w++)
    // [283] stage_logic::w1#1 = ++ stage_logic::w1#2 -- vbum1=_inc_vbum1 
    inc w1
    // [257] phi from stage_logic::@17 to stage_logic::@14 [phi:stage_logic::@17->stage_logic::@14]
    // [257] phi stage_logic::w1#2 = stage_logic::w1#1 [phi:stage_logic::@17->stage_logic::@14#0] -- register_copy 
    jmp __b14
    // stage_logic::stage_playbook_ptr1
  stage_playbook_ptr1:
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [284] stage_logic::stage_playbook_ptr1_stage_playbooks_b#0 = *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) -- pssz1=_deref_qssc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    sta.z stage_playbook_ptr1_stage_playbooks_b
    lda stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    sta.z stage_playbook_ptr1_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [285] stage_logic::$54 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_logic__54
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_logic__54+1
    asl stage_logic__54
    rol stage_logic__54+1
    // [286] stage_logic::$55 = stage_logic::$54 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_logic__55
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_logic__55
    lda stage_logic__55+1
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_logic__55+1
    // [287] stage_logic::stage_playbook_ptr1_$1 = stage_logic::$55 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr1_stage_logic__1
    rol stage_playbook_ptr1_stage_logic__1+1
    // [288] stage_logic::stage_playbook_ptr1_return#0 = stage_logic::stage_playbook_ptr1_stage_playbooks_b#0 + stage_logic::stage_playbook_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr1_stage_logic__1
    clc
    adc.z stage_playbook_ptr1_stage_playbooks_b
    sta.z stage_playbook_ptr1_return
    lda stage_playbook_ptr1_stage_logic__1+1
    adc.z stage_playbook_ptr1_stage_playbooks_b+1
    sta.z stage_playbook_ptr1_return+1
    // stage_logic::stage_scenario_ptr1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_ptr_b->scenarios_b
    // [289] stage_logic::stage_scenario_ptr1_stage_scenarios_b#0 = ((stage_scenario_t **)stage_logic::stage_playbook_ptr1_return#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b
    iny
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b+1
    // &stage_scenarios_b[scenario]
    // [290] stage_logic::stage_scenario_ptr1_$1 = stage_logic::new_scenario#10 << 4 -- vwum1=vwum2_rol_4 
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
    // [291] stage_logic::stage_scenario_ptr1_return#0 = stage_logic::stage_scenario_ptr1_stage_scenarios_b#0 + stage_logic::stage_scenario_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_scenario_ptr1_stage_logic__1
    clc
    adc.z stage_scenario_ptr1_stage_scenarios_b
    sta.z stage_scenario_ptr1_return
    lda stage_scenario_ptr1_stage_logic__1+1
    adc.z stage_scenario_ptr1_stage_scenarios_b+1
    sta.z stage_scenario_ptr1_return+1
    // stage_logic::@25
    // unsigned int prev = stage_scenario_ptr_b->prev
    // [292] stage_logic::prev#0 = (unsigned int)((char *)stage_logic::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_PREV] -- vwum1=_word_pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_PREV
    lda (stage_scenario_ptr1_return),y
    sta prev
    lda #0
    sta prev+1
    // if(prev == wave_scenario)
    // [293] if(stage_logic::prev#0!=stage_logic::wave_scenario#0) goto stage_logic::@20 -- vwum1_neq_vwum2_then_la1 
    cmp wave_scenario+1
    bne __b20
    lda prev
    cmp wave_scenario
    bne __b20
    // stage_logic::@21
    // stage.ew+1
    // [294] stage_logic::$21 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_EW) + 1 -- vwum1=_deref_pwuc1_plus_1 
    clc
    lda stage+OFFSET_STRUCT_STAGE_T_EW
    adc #1
    sta stage_logic__21
    lda stage+OFFSET_STRUCT_STAGE_T_EW+1
    adc #0
    sta stage_logic__21+1
    // (stage.ew+1) & 0x07
    // [295] stage_logic::$22 = stage_logic::$21 & 7 -- vbuaa=vwum1_band_vbuc1 
    lda #7
    and stage_logic__21
    // stage.ew = (stage.ew+1) & 0x07
    // [296] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_EW) = stage_logic::$22 -- _deref_pwuc1=vbuaa 
    // We create new waves from the scenarios that are dependent on the finished one.
    // There must always be at least one that equals scenario of the previous scenario.
    sta stage+OFFSET_STRUCT_STAGE_T_EW
    lda #0
    sta stage+OFFSET_STRUCT_STAGE_T_EW+1
    // stage_copy(stage.ew, new_scenario)
    // [297] stage_copy::ew#1 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_EW) -- vbum1=_deref_pwuc1 
    lda stage+OFFSET_STRUCT_STAGE_T_EW
    sta stage_copy.ew
    // [298] stage_copy::scenario#1 = stage_logic::new_scenario#10 -- vwum1=vwum2 
    lda new_scenario
    sta stage_copy.scenario
    lda new_scenario+1
    sta stage_copy.scenario+1
    // [299] call stage_copy
    // [724] phi from stage_logic::@21 to stage_copy [phi:stage_logic::@21->stage_copy]
    // [724] phi stage_copy::ew#2 = stage_copy::ew#1 [phi:stage_logic::@21->stage_copy#0] -- register_copy 
    // [724] phi stage_copy::scenario#2 = stage_copy::scenario#1 [phi:stage_logic::@21->stage_copy#1] -- register_copy 
    jsr stage_copy
    // stage_logic::@20
  __b20:
    // new_scenario++;
    // [300] stage_logic::new_scenario#1 = ++ stage_logic::new_scenario#10 -- vwum1=_inc_vwum1 
    inc new_scenario
    bne !+
    inc new_scenario+1
  !:
    jmp __b2
    // stage_logic::@5
  __b5:
    // if(wave.used[w])
    // [301] if(0==((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_USED)[stage_logic::w#10]) goto stage_logic::@6 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_USED,y
    cmp #0
    beq __b6
    // stage_logic::@12
    // if(!wave.wait[w])
    // [302] if(0==((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_WAIT)[stage_logic::w#10]) goto stage_logic::@7 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_WAIT,y
    cmp #0
    beq __b7
    // stage_logic::@13
    // wave.wait[w]--;
    // [303] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_WAIT)[stage_logic::w#10] = -- ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_WAIT)[stage_logic::w#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx w
    dec wave+OFFSET_STRUCT_STAGE_WAVE_T_WAIT,x
    // stage_logic::@6
  __b6:
    // for(__mem unsigned char w=0; w<8; w++)
    // [304] stage_logic::w#1 = ++ stage_logic::w#10 -- vbum1=_inc_vbum1 
    inc w
    // [255] phi from stage_logic::@6 to stage_logic::@4 [phi:stage_logic::@6->stage_logic::@4]
    // [255] phi stage_logic::w#10 = stage_logic::w#1 [phi:stage_logic::@6->stage_logic::@4#0] -- register_copy 
    jmp __b4
    // stage_logic::@7
  __b7:
    // if(wave.enemy_count[w])
    // [305] if(0!=((char *)&wave)[stage_logic::w#10]) goto stage_logic::@8 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy w
    lda wave,y
    cmp #0
    bne __b8
    // stage_logic::@10
    // if(!wave.enemy_alive[w])
    // [306] if(0!=((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE)[stage_logic::w#10]) goto stage_logic::@6 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE,y
    cmp #0
    bne __b6
    // stage_logic::@11
    // wave.used[w] = 0
    // [307] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_USED)[stage_logic::w#10] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_USED,y
    // wave.finished[w] = 1
    // [308] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_FINISHED)[stage_logic::w#10] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_FINISHED,y
    jmp __b6
    // stage_logic::@8
  __b8:
    // if(wave.enemy_spawn[w])
    // [309] if(0==((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN)[stage_logic::w#10]) goto stage_logic::@6 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN,y
    cmp #0
    beq __b6
    // stage_logic::@9
    // stage_enemy_add(w, wave.enemy_sprite[w])
    // [310] stage_enemy_add::w#0 = stage_logic::w#10 -- vbum1=vbum2 
    tya
    sta stage_enemy_add.w
    // [311] stage_enemy_add::enemy_sprite#0 = ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPRITE)[stage_logic::w#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldx wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPRITE,y
    // [312] call stage_enemy_add
    jsr stage_enemy_add
    jmp __b6
  .segment DataEngineStages
    .label stage_logic__21 = stage_logic__54
    .label stage_playbook_ptr1_stage_logic__1 = stage_logic__54
    .label stage_scenario_ptr1_stage_logic__1 = stage_logic__54
    .label stage_playbook_ptr2_stage_logic__1 = new_scenario
    w: .byte 0
    .label w1 = w
    new_scenario: .word 0
    wave_scenario: .word 0
    .label prev = stage_logic__54
    stage_logic__54: .word 0
    .label stage_logic__55 = stage_logic__54
    .label stage_logic__57 = new_scenario
    .label stage_logic__58 = new_scenario
}
.segment CodeEnginePlayers
  // player_logic
// void player_logic()
// __bank(cx16_ram, 9) 
player_logic: {
    // flight_index_t p = flight_root(FLIGHT_PLAYER)
    // [313] flight_root::type = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_flightengine.flight_root.type
    // [314] callexecute flight_root  -- call_var_near 
    jsr equinoxe_flightengine.flight_root
    // [315] player_logic::p#0 = flight_root::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_root.return
    sta p
    // [316] phi from player_logic player_logic::@3 to player_logic::@1 [phi:player_logic/player_logic::@3->player_logic::@1]
    // [316] phi player_logic::p#10 = player_logic::p#0 [phi:player_logic/player_logic::@3->player_logic::@1#0] -- register_copy 
    // player_logic::@1
  __b1:
    // while(p)
    // [317] if(0!=player_logic::p#10) goto player_logic::@2 -- 0_neq_vbum1_then_la1 
    lda p
    bne __b2
    // player_logic::@return
    // }
    // [318] return 
    rts
    // player_logic::@2
  __b2:
    // flight_index_t pn = flight_next(p)
    // [319] flight_next::i = player_logic::p#10 -- vbum1=vbum2 
    lda p
    sta equinoxe_flightengine.flight_next.i
    // [320] callexecute flight_next  -- call_var_near 
    jsr equinoxe_flightengine.flight_next
    // [321] player_logic::p#1 = flight_next::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_next.return
    sta p_1
    // if (flight.type[p] == FLIGHT_PLAYER && flight.used[p])
    // [322] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[player_logic::p#10]!=0) goto player_logic::@3 -- pbuc1_derefidx_vbum1_neq_0_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #0
    bne __b3
    // player_logic::@15
    // [323] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[player_logic::p#10]) goto player_logic::@13 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne __b13
    // player_logic::@3
  __b3:
    // [324] player_logic::p#17 = player_logic::p#1 -- vbum1=vbum2 
    lda p_1
    sta p
    jmp __b1
    // player_logic::@13
  __b13:
    // if (flight.reload[p] > 0)
    // [325] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10]<=0) goto player_logic::@4 -- pbuc1_derefidx_vbum1_le_0_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    cmp #0
    beq __b4
    // player_logic::@14
    // flight.reload[p]--;
    // [326] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10] = -- ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx p
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,x
    // player_logic::@4
  __b4:
    // if (cx16_mouse.status == 1 && flight.reload[p] <= 0)
    // [327] if(*((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS)!=1) goto player_logic::@5 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #1
    cmp cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS
    bne __b5
    // player_logic::@16
    // [328] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10]<=0) goto player_logic::@9 -- pbuc1_derefidx_vbum1_le_0_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    cmp #0
    bne !__b9+
    jmp __b9
  !__b9:
    // player_logic::@5
  __b5:
    // flight.xi[p] = (unsigned int)cx16_mouse.x
    // [329] player_logic::$25 = player_logic::p#10 << 1 -- vbum1=vbum2_rol_1 
    lda p
    asl
    sta player_logic__25
    // [330] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$25] = *((unsigned int *)&cx16_mouse) -- pwuc1_derefidx_vbum1=_deref_pwuc2 
    tay
    lda cx16_mouse
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,y
    lda cx16_mouse+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,y
    // flight.yi[p] = (unsigned int)cx16_mouse.y
    // [331] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$25] = *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y) -- pwuc1_derefidx_vbum1=_deref_pwuc2 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,y
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,y
    // flight_index_t n = flight.engine[p]
    // [332] player_logic::n#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENGINE)[player_logic::p#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENGINE,y
    sta n
    // flight.xi[p]+8
    // [333] player_logic::$15 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$25] + 8 -- vwum1=pwuc1_derefidx_vbum2_plus_vbuc2 
    lda #8
    ldy player_logic__25
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,y
    sta player_logic__15
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,y
    adc #0
    sta player_logic__15+1
    // flight.xi[n] = flight.xi[p]+8
    // [334] player_logic::$29 = player_logic::n#0 << 1 -- vbuxx=vbum1_rol_1 
    lda n
    asl
    tax
    // [335] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$29] = player_logic::$15 -- pwuc1_derefidx_vbuxx=vwum1 
    lda player_logic__15
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda player_logic__15+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[p]+32
    // [336] player_logic::$16 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$25] + $20 -- vwum1=pwuc1_derefidx_vbum2_plus_vbuc2 
    lda #$20
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,y
    sta player_logic__16
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,y
    adc #0
    sta player_logic__16+1
    // flight.yi[n] = flight.yi[p]+32
    // [337] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$29] = player_logic::$16 -- pwuc1_derefidx_vbuxx=vwum1 
    lda player_logic__16
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda player_logic__16+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // unsigned int x = flight.xi[p]
    // [338] player_logic::x1#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$25] -- vwum1=pwuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,y
    sta x1
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,y
    sta x1+1
    // unsigned int y = flight.yi[p]
    // [339] player_logic::y1#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$25] -- vwum1=pwuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,y
    sta y1
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,y
    sta y1+1
    // if (x > 640 - 32)
    // [340] if(player_logic::x1#0<=$280-$20) goto player_logic::@7 -- vwum1_le_vwuc1_then_la1 
    lda x1+1
    cmp #>$280-$20
    bne !+
    lda x1
    cmp #<$280-$20
  !:
    // [341] phi from player_logic::@5 to player_logic::@11 [phi:player_logic::@5->player_logic::@11]
    // player_logic::@11
    // player_logic::@7
    // if (y > 480 - 32)
    // [342] if(player_logic::y1#0<=$1e0-$20) goto player_logic::@8 -- vwum1_le_vwuc1_then_la1 
    lda y1+1
    cmp #>$1e0-$20
    bne !+
    lda y1
    cmp #<$1e0-$20
  !:
    // [343] phi from player_logic::@7 to player_logic::@12 [phi:player_logic::@7->player_logic::@12]
    // player_logic::@12
    // player_logic::@8
    // unsigned char ap = flight.animate[p]
    // [344] player_logic::ap#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_logic::p#10] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // animate_player(ap, (signed int)cx16_mouse.x, (signed int)cx16_mouse.px)
    // [345] animate_player::a = player_logic::ap#0 -- vbum1=vbuaa 
    sta equinoxe_animate.animate_player.a
    // [346] animate_player::x = (int)*((unsigned int *)&cx16_mouse) -- vwsm1=_deref_pwsc1 
    lda cx16_mouse
    sta equinoxe_animate.animate_player.x
    lda cx16_mouse+1
    sta equinoxe_animate.animate_player.x+1
    // [347] animate_player::px = (int)*((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX) -- vwsm1=_deref_pwsc1 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX
    sta equinoxe_animate.animate_player.px
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX+1
    sta equinoxe_animate.animate_player.px+1
    // [348] callexecute animate_player  -- call_var_near 
    jsr equinoxe_animate.animate_player
    // unsigned char an = flight.animate[n]
    // [349] player_logic::an#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_logic::n#0] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy n
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // animate_logic(an)
    // [350] animate_logic::a = player_logic::an#0 -- vbum1=vbuaa 
    sta equinoxe_animate.animate_logic.a
    // [351] callexecute animate_logic  -- call_var_near 
    jsr equinoxe_animate.animate_logic
    // collision_insert(p)
    // [352] collision_insert::f#0 = player_logic::p#10 -- vbum1=vbum2 
    lda p
    sta collision_insert.f
    // [353] call collision_insert
    // [765] phi from player_logic::@8 to collision_insert [phi:player_logic::@8->collision_insert]
    // [765] phi collision_insert::f#3 = collision_insert::f#0 [phi:player_logic::@8->collision_insert#0] -- register_copy 
    jsr collision_insert
    jmp __b3
    // player_logic::@9
  __b9:
    // unsigned int x = flight.xi[p]
    // [354] player_logic::$35 = player_logic::p#10 << 1 -- vbuxx=vbum1_rol_1 
    lda p
    asl
    tax
    // [355] player_logic::x#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$35] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    sta x
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    sta x+1
    // unsigned int y = flight.yi[p]
    // [356] player_logic::y#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$35] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    sta y
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    sta y+1
    // if (flight.firegun[p])
    // [357] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN)[player_logic::p#10]) goto player_logic::@6 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN,y
    cmp #0
    beq __b6
    // player_logic::@10
    // x += (signed char)16
    // [358] player_logic::x#1 = player_logic::x#0 + $10 -- vwum1=vwum1_plus_vbsc1 
    lda #$10
    clc
    sta.z $ff
    adc x
    sta x
    lda.z $ff
    ora #$7f
    bmi !+
    lda #0
  !:
    adc x+1
    sta x+1
    // [359] phi from player_logic::@10 player_logic::@9 to player_logic::@6 [phi:player_logic::@10/player_logic::@9->player_logic::@6]
    // [359] phi player_logic::x#2 = player_logic::x#1 [phi:player_logic::@10/player_logic::@9->player_logic::@6#0] -- register_copy 
    // player_logic::@6
  __b6:
    // flight.firegun[p] ^ 1
    // [360] player_logic::$13 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN)[player_logic::p#10] ^ 1 -- vbuaa=pbuc1_derefidx_vbum1_bxor_vbuc2 
    lda #1
    ldy p
    eor equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN,y
    // flight.firegun[p] = flight.firegun[p] ^ 1
    // [361] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN)[player_logic::p#10] = player_logic::$13 -- pbuc1_derefidx_vbum1=vbuaa 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN,y
    // flight.reload[p] = 8
    // [362] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10] = 8 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #8
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    // stage_bullet_add(x, y, x, 0, 5, SIDE_PLAYER, b001)
    // [363] stage_bullet_add::sx#0 = player_logic::x#2 -- vwum1=vwum2 
    lda x
    sta stage_bullet_add.sx
    lda x+1
    sta stage_bullet_add.sx+1
    // [364] stage_bullet_add::sy#0 = player_logic::y#0 -- vwum1=vwum2 
    lda y
    sta stage_bullet_add.sy
    lda y+1
    sta stage_bullet_add.sy+1
    // [365] stage_bullet_add::tx#0 = player_logic::x#2 -- vwum1=vwum2 
    lda x
    sta stage_bullet_add.tx
    lda x+1
    sta stage_bullet_add.tx+1
    // [366] call stage_bullet_add
    // [799] phi from player_logic::@6 to stage_bullet_add [phi:player_logic::@6->stage_bullet_add]
    // [799] phi stage_bullet_add::sprite_bullet#2 = $11 [phi:player_logic::@6->stage_bullet_add#0] -- vbum1=vbuc1 
    lda #$11
    sta stage_bullet_add.sprite_bullet
    // [799] phi stage_bullet_add::side#2 = 0 [phi:player_logic::@6->stage_bullet_add#1] -- vbuxx=vbuc1 
    ldx #0
    // [799] phi stage_bullet_add::speed#2 = 5 [phi:player_logic::@6->stage_bullet_add#2] -- vbuyy=vbuc1 
    ldy #5
    // [799] phi stage_bullet_add::ty#2 = 0 [phi:player_logic::@6->stage_bullet_add#3] -- vwum1=vbuc1 
    txa
    sta stage_bullet_add.ty
    sta stage_bullet_add.ty+1
    // [799] phi stage_bullet_add::tx#2 = stage_bullet_add::tx#0 [phi:player_logic::@6->stage_bullet_add#4] -- register_copy 
    // [799] phi stage_bullet_add::sy#2 = stage_bullet_add::sy#0 [phi:player_logic::@6->stage_bullet_add#5] -- register_copy 
    // [799] phi stage_bullet_add::sx#2 = stage_bullet_add::sx#0 [phi:player_logic::@6->stage_bullet_add#6] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_bullet_add
    .byte >stage_bullet_add
    .byte 3
    jmp __b5
  .segment DataEnginePlayers
    .label player_logic__15 = x
    .label player_logic__16 = x
    player_logic__25: .byte 0
    p: .byte 0
    p_1: .byte 0
    n: .byte 0
    .label x1 = x
    y1: .word 0
    x: .word 0
    .label y = y1
}
.segment CodeEngineBullets
  // bullet_logic
// void bullet_logic()
// __bank(cx16_ram, 7) 
bullet_logic: {
    .label xf = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XF
    .label yf = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YF
    .label xi = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI
    .label yi = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI
    .label xd = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD
    .label yd = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD
    // flight_index_t b = flight_root(FLIGHT_BULLET)
    // [367] flight_root::type = 3 -- vbum1=vbuc1 
    lda #3
    sta equinoxe_flightengine.flight_root.type
    // [368] callexecute flight_root  -- call_var_near 
    jsr equinoxe_flightengine.flight_root
    // [369] bullet_logic::b#0 = flight_root::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_root.return
    sta b
    // [370] phi from bullet_logic bullet_logic::@3 to bullet_logic::@1 [phi:bullet_logic/bullet_logic::@3->bullet_logic::@1]
    // [370] phi bullet_logic::b#2 = bullet_logic::b#0 [phi:bullet_logic/bullet_logic::@3->bullet_logic::@1#0] -- register_copy 
    // bullet_logic::@1
  __b1:
    // while(b)
    // [371] if(0!=bullet_logic::b#2) goto bullet_logic::@2 -- 0_neq_vbum1_then_la1 
    lda b
    bne __b2
    // bullet_logic::@return
    // }
    // [372] return 
    rts
    // bullet_logic::@2
  __b2:
    // flight_index_t bn = flight_next(b)
    // [373] flight_next::i = bullet_logic::b#2 -- vbum1=vbum2 
    lda b
    sta equinoxe_flightengine.flight_next.i
    // [374] callexecute flight_next  -- call_var_near 
    jsr equinoxe_flightengine.flight_next
    // [375] bullet_logic::b#1 = flight_next::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_next.return
    sta b_1
    // if(flight.type[b] == FLIGHT_BULLET && flight.used[b])
    // [376] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[bullet_logic::b#2]!=3) goto bullet_logic::@3 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #3
    ldy b
    cmp equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    bne __b3
    // bullet_logic::@7
    // [377] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[bullet_logic::b#2]) goto bullet_logic::@5 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne __b5
    // bullet_logic::@3
  __b3:
    // [378] bullet_logic::b#8 = bullet_logic::b#1 -- vbum1=vbum2 
    lda b_1
    sta b
    jmp __b1
    // bullet_logic::@5
  __b5:
    // kickasm
    // kickasm( uses bullet_logic::xf uses bullet_logic::yf uses bullet_logic::xi uses bullet_logic::yi uses bullet_logic::xd uses bullet_logic::yd) {{ lda b                 asl                 tay                 ldx b                 lda xf,x        // Load the fractional part of the coordinate.                 clc             // For addition, clear the carry.                 adc xd,y        // Add the low byte (=fractional part) of the delta.                 sta xf,x        // Store the low byte of the delta in the fractional part of the coordinate.                 lda xi,y        // Load the low byte of the integer part of the coordinate.                 adc xd+1,y      // Add the high byte (=integer part) of the delta.                 sta xi,y        // Store the result in the low byte of the integer part of the coordinate.                 lda xd+1,y      // Load back the high byte of the axis delta, it may be negative.                 ora #$7f        // We check the sign bit.                 bmi !+          // If it was minus, the result in A will be $FF.                 lda #0          // The result was not minus, so just add carry.                 !:                 adc xi+1,y      // Now do the signed final addition.                 sta xi+1,y      // And store the result, we're done.                  lda yf,x        // Load the fractional part of the coordinate.                 clc             // For addition, clear the carry.                 adc yd,y        // Add the low byte (=fractional part) of the delta.                 sta yf,x        // Store the low byte of the delta in the fractional part of the coordinate.                 lda yi,y        // Load the low byte of the integer part of the coordinate.                 adc yd+1,y      // Add the high byte (=integer part) of the delta.                 sta yi,y        // Store the result in the low byte of the integer part of the coordinate.                 lda yd+1,y      // Load back the high byte of the delta, it may be negative.                 ora #$7f        // We check the sign bit.                 bmi !+          // If it was minus, the result in A will be $FF.                 lda #0          // The result was not minus, so just add carry.                 !:                 adc yi+1,y      // Now do the signed final addition.                 sta yi+1,y      // And store the result, we're done.              }}
    lda b
                asl
                tay
                ldx b
                lda xf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc xd,y        // Add the low byte (=fractional part) of the delta.
                sta xf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda xi,y        // Load the low byte of the integer part of the coordinate.
                adc xd+1,y      // Add the high byte (=integer part) of the delta.
                sta xi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda xd+1,y      // Load back the high byte of the axis delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc xi+1,y      // Now do the signed final addition.
                sta xi+1,y      // And store the result, we're done.

                lda yf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc yd,y        // Add the low byte (=fractional part) of the delta.
                sta yf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda yi,y        // Load the low byte of the integer part of the coordinate.
                adc yd+1,y      // Add the high byte (=integer part) of the delta.
                sta yi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda yd+1,y      // Load back the high byte of the delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc yi+1,y      // Now do the signed final addition.
                sta yi+1,y      // And store the result, we're done.
            
    // unsigned int x = flight.xi[b]
    // [380] bullet_logic::$17 = bullet_logic::b#2 << 1 -- vbuxx=vbum1_rol_1 
    lda b
    asl
    tax
    // [381] bullet_logic::x#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[bullet_logic::$17] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    sta x
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    sta x+1
    // unsigned int y = flight.yi[b]
    // [382] bullet_logic::y#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[bullet_logic::$17] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    sta y
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    sta y+1
    // if(x<640 && y<480 && x<0xFFFF-32 && y<0xFFFF-32)
    // [383] if(bullet_logic::x#0>=$280) goto bullet_logic::@6 -- vwum1_ge_vwuc1_then_la1 
    lda x+1
    cmp #>$280
    bcc !+
    bne __b6
    lda x
    cmp #<$280
    bcs __b6
  !:
    // bullet_logic::@10
    // [384] if(bullet_logic::y#0<$1e0) goto bullet_logic::@9 -- vwum1_lt_vwuc1_then_la1 
    lda y+1
    cmp #>$1e0
    bcc __b9
    bne !+
    lda y
    cmp #<$1e0
    bcc __b9
  !:
    // bullet_logic::@6
  __b6:
    // bullet_remove(b)
    // [385] bullet_remove::b#1 = bullet_logic::b#2 -- vbum1=vbum2 
    lda b
    sta bullet_remove.b
    // [386] call bullet_remove
    // [810] phi from bullet_logic::@6 to bullet_remove [phi:bullet_logic::@6->bullet_remove]
    // [810] phi bullet_remove::b#2 = bullet_remove::b#1 [phi:bullet_logic::@6->bullet_remove#0] -- register_copy 
    jsr bullet_remove
    jmp __b3
    // bullet_logic::@9
  __b9:
    // if(x<640 && y<480 && x<0xFFFF-32 && y<0xFFFF-32)
    // [387] if(bullet_logic::x#0>=$ffff-$20) goto bullet_logic::@6 -- vwum1_ge_vwuc1_then_la1 
    lda x+1
    cmp #>$ffff-$20
    bcc !+
    bne __b6
    lda x
    cmp #<$ffff-$20
    bcs __b6
  !:
    // bullet_logic::@8
    // [388] if(bullet_logic::y#0<$ffff-$20) goto bullet_logic::@4 -- vwum1_lt_vwuc1_then_la1 
    lda y+1
    cmp #>$ffff-$20
    bcc __b4
    bne !+
    lda y
    cmp #<$ffff-$20
    bcc __b4
  !:
    jmp __b6
    // bullet_logic::@4
  __b4:
    // unsigned char volatile a = flight.animate[b]
    // [389] bullet_logic::a = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[bullet_logic::b#2] -- vbum1=pbuc1_derefidx_vbum2 
    //     if(!flight.enabled[b]) {
    // vera_sprite_zdepth(sprite_offset, sprite_cache.zdepth[flight.sprite[b]]);
    //         flight.enabled[b] = 1;
    //     }
    ldy b
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta a
    // animate_logic(a)
    // [390] animate_logic::a = bullet_logic::a -- vbum1=vbum2 
    // 	if(animate_is_waiting(a)) {
    // 		vera_sprite_set_xy(sprite_offset, (signed int)x, (signed int)y);
    // 	} else {
    // 		// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)flight.sprite[b]*16+flight.state_animation[b]]);
    // 		vera_sprite_set_xy_and_image_offset(sprite_offset, (signed int)x, (signed int)y, sprite_image_cache_vram(flight.sprite[b], animate_get_state(a)));
    // 	}
    sta equinoxe_animate.animate_logic.a
    // [391] callexecute animate_logic  -- call_var_near 
    jsr equinoxe_animate.animate_logic
    // collision_insert(b)
    // [392] collision_insert::f#1 = bullet_logic::b#2 -- vbum1=vbum2 
    lda b
    sta collision_insert.f
    // [393] call collision_insert
    // [765] phi from bullet_logic::@4 to collision_insert [phi:bullet_logic::@4->collision_insert]
    // [765] phi collision_insert::f#3 = collision_insert::f#1 [phi:bullet_logic::@4->collision_insert#0] -- register_copy 
    jsr collision_insert
    jmp __b3
  .segment DataEngineBullets
    a: .byte 0
    b: .byte 0
    b_1: .byte 0
    .label x = bullet_add.dx
    y: .word 0
}
.segment CodeEngineEnemies
  // enemy_logic
// void enemy_logic()
// __bank(cx16_ram, 8) 
enemy_logic: {
    .label xf = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XF
    .label yf = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YF
    .label xi = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI
    .label yi = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI
    .label xd = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD
    .label yd = equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD
    .label enemy_flightpath = $51
    .label action = $53
    .label math_vecx1_return = $47
    .label math_vecy1_return = $47
    .label math_vecx2_return = $47
    .label math_vecy2_return = $47
    // flight_index_t e = flight_root(FLIGHT_ENEMY)
    // [394] flight_root::type = 1 -- vbum1=vbuc1 
    lda #1
    sta equinoxe_flightengine.flight_root.type
    // [395] callexecute flight_root  -- call_var_near 
    jsr equinoxe_flightengine.flight_root
    // [396] enemy_logic::e#0 = flight_root::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_root.return
    sta e
    // [397] phi from enemy_logic enemy_logic::@12 enemy_logic::@3 to enemy_logic::@1 [phi:enemy_logic/enemy_logic::@12/enemy_logic::@3->enemy_logic::@1]
    // [397] phi enemy_logic::e#10 = enemy_logic::e#0 [phi:enemy_logic/enemy_logic::@12/enemy_logic::@3->enemy_logic::@1#0] -- register_copy 
    // enemy_logic::@1
  __b1:
    // while(e)
    // [398] if(0!=enemy_logic::e#10) goto enemy_logic::@2 -- 0_neq_vbum1_then_la1 
    lda e
    bne __b2
    // enemy_logic::@return
    // }
    // [399] return 
    rts
    // enemy_logic::@2
  __b2:
    // flight_index_t en = flight_next(e)
    // [400] flight_next::i = enemy_logic::e#10 -- vbum1=vbum2 
    lda e
    sta equinoxe_flightengine.flight_next.i
    // [401] callexecute flight_next  -- call_var_near 
    jsr equinoxe_flightengine.flight_next
    // [402] enemy_logic::e#1 = flight_next::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_next.return
    sta e_1
    // if(flight.type[e] == FLIGHT_ENEMY && flight.used[e])
    // [403] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[enemy_logic::e#10]!=1) goto enemy_logic::@3 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #1
    ldy e
    cmp equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    bne __b3
    // enemy_logic::@39
    // [404] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[enemy_logic::e#10]) goto enemy_logic::@19 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne __b19
    // enemy_logic::@3
  __b3:
    // [405] enemy_logic::e#58 = enemy_logic::e#1 -- vbum1=vbum2 
    lda e_1
    sta e
    jmp __b1
    // enemy_logic::@19
  __b19:
    // !flight.moving[e]
    // [406] enemy_logic::$41 = enemy_logic::e#10 << 1 -- vbum1=vbum2_rol_1 
    lda e
    asl
    sta enemy_logic__41
    // if(!flight.moving[e])
    // [407] if(0==((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_logic::$41]) goto enemy_logic::@4 -- 0_eq_pwuc1_derefidx_vbum1_then_la1 
    tay
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,y
    ora equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,y
    bne !__b4+
    jmp __b4
  !__b4:
    // enemy_logic::@20
    // flight.moving[e]--;
    // [408] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_logic::$41] = -- ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_logic::$41] -- pwuc1_derefidx_vbum1=_dec_pwuc1_derefidx_vbum1 
    ldx enemy_logic__41
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,x
    bne !+
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,x
  !:
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,x
    // if( flight.move[e])
    // [409] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_logic::e#10]) goto enemy_logic::@9 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    cmp #0
    bne !__b9+
    jmp __b9
  !__b9:
    // enemy_logic::@21
    // if(flight.move[e] == 1)
    // [410] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_logic::e#10]!=1) goto enemy_logic::@5 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #1
    cmp equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    beq !__b5+
    jmp __b5
  !__b5:
    // enemy_logic::@22
    // math_vecx(flight.angle[e], flight.speed[e])
    // [411] enemy_logic::math_vecx1_angle#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // [412] enemy_logic::math_vecx1_speed#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    sta math_vecx1_speed
    // enemy_logic::math_vecx1
    // if (speed)
    // [413] if(0==enemy_logic::math_vecx1_speed#0) goto enemy_logic::math_vecx1_@1 -- 0_eq_vbum1_then_la1 
    beq __b7
    // enemy_logic::math_vecx1_@2
    // angle % 64
    // [414] enemy_logic::math_vecx1_$1 = enemy_logic::math_vecx1_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dx = math_cos[angle % 64]
    // [415] enemy_logic::math_vecx1_$2 = enemy_logic::math_vecx1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [416] enemy_logic::math_vecx1_dx#1 = math_cos[enemy_logic::math_vecx1_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_cos,y
    sta math_vecx1_dx
    lda math_cos+1,y
    sta math_vecx1_dx+1
    // dx <<= speed
    // [417] enemy_logic::math_vecx1_dx#2 = enemy_logic::math_vecx1_dx#1 << enemy_logic::math_vecx1_speed#0 -- vwsm1=vwsm1_rol_vbum2 
    ldy math_vecx1_speed
    beq !e+
  !:
    asl math_vecx1_dx
    rol math_vecx1_dx+1
    dey
    bne !-
  !e:
    // [418] phi from enemy_logic::math_vecx1_@2 to enemy_logic::math_vecx1_@1 [phi:enemy_logic::math_vecx1_@2->enemy_logic::math_vecx1_@1]
    // [418] phi enemy_logic::math_vecx1_return#0 = enemy_logic::math_vecx1_dx#2 [phi:enemy_logic::math_vecx1_@2->enemy_logic::math_vecx1_@1#0] -- vwsz1=vwsm2 
    lda math_vecx1_dx
    sta.z math_vecx1_return
    lda math_vecx1_dx+1
    sta.z math_vecx1_return+1
    jmp __b23
    // [418] phi from enemy_logic::math_vecx1 to enemy_logic::math_vecx1_@1 [phi:enemy_logic::math_vecx1->enemy_logic::math_vecx1_@1]
  __b7:
    // [418] phi enemy_logic::math_vecx1_return#0 = 0 [phi:enemy_logic::math_vecx1->enemy_logic::math_vecx1_@1#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z math_vecx1_return
    sta.z math_vecx1_return+1
    // enemy_logic::math_vecx1_@1
    // enemy_logic::@23
  __b23:
    // flight.xd[e] = (unsigned int)math_vecx(flight.angle[e], flight.speed[e])
    // [419] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[enemy_logic::$41] = (unsigned int)enemy_logic::math_vecx1_return#0 -- pwuc1_derefidx_vbum1=vwuz2 
    ldy enemy_logic__41
    lda.z math_vecx1_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,y
    lda.z math_vecx1_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,y
    // math_vecy(flight.angle[e], flight.speed[e])
    // [420] enemy_logic::math_vecy1_angle#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy e
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // [421] enemy_logic::math_vecy1_speed#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    sta math_vecy1_speed
    // enemy_logic::math_vecy1
    // if (speed)
    // [422] if(0==enemy_logic::math_vecy1_speed#0) goto enemy_logic::math_vecy1_@1 -- 0_eq_vbum1_then_la1 
    beq __b8
    // enemy_logic::math_vecy1_@2
    // angle % 64
    // [423] enemy_logic::math_vecy1_$1 = enemy_logic::math_vecy1_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dy = math_sin[angle % 64]
    // [424] enemy_logic::math_vecy1_$2 = enemy_logic::math_vecy1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [425] enemy_logic::math_vecy1_dy#1 = math_sin[enemy_logic::math_vecy1_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_sin,y
    sta math_vecy1_dy
    lda math_sin+1,y
    sta math_vecy1_dy+1
    // dy <<= speed
    // [426] enemy_logic::math_vecy1_dy#2 = enemy_logic::math_vecy1_dy#1 << enemy_logic::math_vecy1_speed#0 -- vwsm1=vwsm1_rol_vbum2 
    ldy math_vecy1_speed
    beq !e+
  !:
    asl math_vecy1_dy
    rol math_vecy1_dy+1
    dey
    bne !-
  !e:
    // [427] phi from enemy_logic::math_vecy1_@2 to enemy_logic::math_vecy1_@1 [phi:enemy_logic::math_vecy1_@2->enemy_logic::math_vecy1_@1]
    // [427] phi enemy_logic::math_vecy1_return#0 = enemy_logic::math_vecy1_dy#2 [phi:enemy_logic::math_vecy1_@2->enemy_logic::math_vecy1_@1#0] -- vwsz1=vwsm2 
    lda math_vecy1_dy
    sta.z math_vecy1_return
    lda math_vecy1_dy+1
    sta.z math_vecy1_return+1
    jmp __b24
    // [427] phi from enemy_logic::math_vecy1 to enemy_logic::math_vecy1_@1 [phi:enemy_logic::math_vecy1->enemy_logic::math_vecy1_@1]
  __b8:
    // [427] phi enemy_logic::math_vecy1_return#0 = 0 [phi:enemy_logic::math_vecy1->enemy_logic::math_vecy1_@1#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z math_vecy1_return
    sta.z math_vecy1_return+1
    // enemy_logic::math_vecy1_@1
    // enemy_logic::@24
  __b24:
    // flight.yd[e] = (unsigned int)math_vecy(flight.angle[e], flight.speed[e])
    // [428] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[enemy_logic::$41] = (unsigned int)enemy_logic::math_vecy1_return#0 -- pwuc1_derefidx_vbum1=vwuz2 
    ldy enemy_logic__41
    lda.z math_vecy1_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,y
    lda.z math_vecy1_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,y
    // flight.move[e] = 0
    // [429] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_logic::e#10] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    // enemy_logic::@5
  __b5:
    // if(flight.move[e] == 2)
    // [430] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_logic::e#10]!=2) goto enemy_logic::@9 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #2
    ldy e
    cmp equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    beq !__b9+
    jmp __b9
  !__b9:
    // enemy_logic::@7
    // if(!flight.delay[e])
    // [431] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_logic::e#10]) goto enemy_logic::@6 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,y
    cmp #0
    beq !__b6+
    jmp __b6
  !__b6:
    // enemy_logic::@8
    // flight.angle[e] += flight.turn[e]
    // [432] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] + ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TURN)[enemy_logic::e#10] -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_pbuc2_derefidx_vbum1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TURN,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // flight.angle[e] %= 64
    // [433] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] & $40-1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_band_vbuc2 
    lda #$40-1
    and equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // flight.delay[e] = flight.radius[e]
    // [434] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_logic::e#10] = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RADIUS)[enemy_logic::e#10] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RADIUS,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,y
    // math_vecx(flight.angle[e], flight.speed[e])
    // [435] enemy_logic::math_vecx2_angle#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // [436] enemy_logic::math_vecx2_speed#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    sta math_vecx2_speed
    // enemy_logic::math_vecx2
    // if (speed)
    // [437] if(0==enemy_logic::math_vecx2_speed#0) goto enemy_logic::math_vecx2_@1 -- 0_eq_vbum1_then_la1 
    beq __b15
    // enemy_logic::math_vecx2_@2
    // angle % 64
    // [438] enemy_logic::math_vecx2_$1 = enemy_logic::math_vecx2_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dx = math_cos[angle % 64]
    // [439] enemy_logic::math_vecx2_$2 = enemy_logic::math_vecx2_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [440] enemy_logic::math_vecx2_dx#1 = math_cos[enemy_logic::math_vecx2_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_cos,y
    sta math_vecx2_dx
    lda math_cos+1,y
    sta math_vecx2_dx+1
    // dx <<= speed
    // [441] enemy_logic::math_vecx2_dx#2 = enemy_logic::math_vecx2_dx#1 << enemy_logic::math_vecx2_speed#0 -- vwsm1=vwsm1_rol_vbum2 
    ldy math_vecx2_speed
    beq !e+
  !:
    asl math_vecx2_dx
    rol math_vecx2_dx+1
    dey
    bne !-
  !e:
    // [442] phi from enemy_logic::math_vecx2_@2 to enemy_logic::math_vecx2_@1 [phi:enemy_logic::math_vecx2_@2->enemy_logic::math_vecx2_@1]
    // [442] phi enemy_logic::math_vecx2_return#0 = enemy_logic::math_vecx2_dx#2 [phi:enemy_logic::math_vecx2_@2->enemy_logic::math_vecx2_@1#0] -- vwsz1=vwsm2 
    lda math_vecx2_dx
    sta.z math_vecx2_return
    lda math_vecx2_dx+1
    sta.z math_vecx2_return+1
    jmp __b25
    // [442] phi from enemy_logic::math_vecx2 to enemy_logic::math_vecx2_@1 [phi:enemy_logic::math_vecx2->enemy_logic::math_vecx2_@1]
  __b15:
    // [442] phi enemy_logic::math_vecx2_return#0 = 0 [phi:enemy_logic::math_vecx2->enemy_logic::math_vecx2_@1#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z math_vecx2_return
    sta.z math_vecx2_return+1
    // enemy_logic::math_vecx2_@1
    // enemy_logic::@25
  __b25:
    // flight.xd[e] = (unsigned int)math_vecx(flight.angle[e], flight.speed[e])
    // [443] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[enemy_logic::$41] = (unsigned int)enemy_logic::math_vecx2_return#0 -- pwuc1_derefidx_vbum1=vwuz2 
    ldy enemy_logic__41
    lda.z math_vecx2_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,y
    lda.z math_vecx2_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,y
    // math_vecy(flight.angle[e], flight.speed[e])
    // [444] enemy_logic::math_vecy2_angle#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_logic::e#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy e
    ldx equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,y
    // [445] enemy_logic::math_vecy2_speed#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    sta math_vecy2_speed
    // enemy_logic::math_vecy2
    // if (speed)
    // [446] if(0==enemy_logic::math_vecy2_speed#0) goto enemy_logic::math_vecy2_@1 -- 0_eq_vbum1_then_la1 
    beq __b16
    // enemy_logic::math_vecy2_@2
    // angle % 64
    // [447] enemy_logic::math_vecy2_$1 = enemy_logic::math_vecy2_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dy = math_sin[angle % 64]
    // [448] enemy_logic::math_vecy2_$2 = enemy_logic::math_vecy2_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [449] enemy_logic::math_vecy2_dy#1 = math_sin[enemy_logic::math_vecy2_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_sin,y
    sta math_vecy2_dy
    lda math_sin+1,y
    sta math_vecy2_dy+1
    // dy <<= speed
    // [450] enemy_logic::math_vecy2_dy#2 = enemy_logic::math_vecy2_dy#1 << enemy_logic::math_vecy2_speed#0 -- vwsm1=vwsm1_rol_vbum2 
    ldy math_vecy2_speed
    beq !e+
  !:
    asl math_vecy2_dy
    rol math_vecy2_dy+1
    dey
    bne !-
  !e:
    // [451] phi from enemy_logic::math_vecy2_@2 to enemy_logic::math_vecy2_@1 [phi:enemy_logic::math_vecy2_@2->enemy_logic::math_vecy2_@1]
    // [451] phi enemy_logic::math_vecy2_return#0 = enemy_logic::math_vecy2_dy#2 [phi:enemy_logic::math_vecy2_@2->enemy_logic::math_vecy2_@1#0] -- vwsz1=vwsm2 
    lda math_vecy2_dy
    sta.z math_vecy2_return
    lda math_vecy2_dy+1
    sta.z math_vecy2_return+1
    jmp __b26
    // [451] phi from enemy_logic::math_vecy2 to enemy_logic::math_vecy2_@1 [phi:enemy_logic::math_vecy2->enemy_logic::math_vecy2_@1]
  __b16:
    // [451] phi enemy_logic::math_vecy2_return#0 = 0 [phi:enemy_logic::math_vecy2->enemy_logic::math_vecy2_@1#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z math_vecy2_return
    sta.z math_vecy2_return+1
    // enemy_logic::math_vecy2_@1
    // enemy_logic::@26
  __b26:
    // flight.yd[e] = (unsigned int)math_vecy(flight.angle[e], flight.speed[e])
    // [452] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[enemy_logic::$41] = (unsigned int)enemy_logic::math_vecy2_return#0 -- pwuc1_derefidx_vbum1=vwuz2 
    ldy enemy_logic__41
    lda.z math_vecy2_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,y
    lda.z math_vecy2_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,y
    // enemy_logic::@6
  __b6:
    // flight.delay[e]--;
    // [453] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_logic::e#10] = -- ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_logic::e#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx e
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,x
    // enemy_logic::@9
  __b9:
    // kickasm
    // kickasm( uses enemy_logic::xf uses enemy_logic::yf uses enemy_logic::xi uses enemy_logic::yi uses enemy_logic::xd uses enemy_logic::yd) {{ lda e                 asl                 tay                 ldx e                 lda xf,x        // Load the fractional part of the coordinate.                 clc             // For addition, clear the carry.                 adc xd,y        // Add the low byte (=fractional part) of the delta.                 sta xf,x        // Store the low byte of the delta in the fractional part of the coordinate.                 lda xi,y        // Load the low byte of the integer part of the coordinate.                 adc xd+1,y      // Add the high byte (=integer part) of the delta.                 sta xi,y        // Store the result in the low byte of the integer part of the coordinate.                 lda xd+1,y      // Load back the high byte of the axis delta, it may be negative.                 ora #$7f        // We check the sign bit.                 bmi !+          // If it was minus, the result in A will be $FF.                 lda #0          // The result was not minus, so just add carry.                 !:                 adc xi+1,y      // Now do the signed final addition.                 sta xi+1,y      // And store the result, we're done.                  lda yf,x        // Load the fractional part of the coordinate.                 clc             // For addition, clear the carry.                 adc yd,y        // Add the low byte (=fractional part) of the delta.                 sta yf,x        // Store the low byte of the delta in the fractional part of the coordinate.                 lda yi,y        // Load the low byte of the integer part of the coordinate.                 adc yd+1,y      // Add the high byte (=integer part) of the delta.                 sta yi,y        // Store the result in the low byte of the integer part of the coordinate.                 lda yd+1,y      // Load back the high byte of the delta, it may be negative.                 ora #$7f        // We check the sign bit.                 bmi !+          // If it was minus, the result in A will be $FF.                 lda #0          // The result was not minus, so just add carry.                 !:                 adc yi+1,y      // Now do the signed final addition.                 sta yi+1,y      // And store the result, we're done.              }}
    lda e
                asl
                tay
                ldx e
                lda xf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc xd,y        // Add the low byte (=fractional part) of the delta.
                sta xf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda xi,y        // Load the low byte of the integer part of the coordinate.
                adc xd+1,y      // Add the high byte (=integer part) of the delta.
                sta xi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda xd+1,y      // Load back the high byte of the axis delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc xi+1,y      // Now do the signed final addition.
                sta xi+1,y      // And store the result, we're done.

                lda yf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc yd,y        // Add the low byte (=fractional part) of the delta.
                sta yf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda yi,y        // Load the low byte of the integer part of the coordinate.
                adc yd+1,y      // Add the high byte (=integer part) of the delta.
                sta yi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda yd+1,y      // Load back the high byte of the delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc yi+1,y      // Now do the signed final addition.
                sta yi+1,y      // And store the result, we're done.
            
    // if (flight.reload[e] > 0)
    // [455] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[enemy_logic::e#10]<=0) goto enemy_logic::@13 -- pbuc1_derefidx_vbum1_le_0_then_la1 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    cmp #0
    beq __b13
    // enemy_logic::@17
    // flight.reload[e]--;
    // [456] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[enemy_logic::e#10] = -- ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[enemy_logic::e#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx e
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,x
    // [457] phi from enemy_logic::@17 enemy_logic::@9 to enemy_logic::@13 [phi:enemy_logic::@17/enemy_logic::@9->enemy_logic::@13]
    // enemy_logic::@13
  __b13:
    // unsigned int r = rand()
    // [458] call rand
    // 	if(animate_is_waiting(flight.animate[e])) {
    // 		vera_sprite_set_xy(sprite_offset, x, y);
    // 	} else {
    // 		// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)flight.sprite[e]*16+flight.state_animation[e]]);
    // 		vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, 
    // 			sprite_image_cache_vram(flight.sprite[e], animate_get_state(flight.animate[e])));
    // 	}
    jsr rand
    // [459] rand::return#3 = rand::return#0
    // enemy_logic::@38
    // [460] enemy_logic::r#0 = rand::return#3 -- vwum1=vwum2 
    lda rand.return
    sta r
    lda rand.return+1
    sta r+1
    // if(r>=65300)
    // [461] if(enemy_logic::r#0<$ff14) goto enemy_logic::@14 -- vwum1_lt_vwuc1_then_la1 
    cmp #>$ff14
    bcc __b14
    bne !+
    lda r
    cmp #<$ff14
    bcc __b14
  !:
    // enemy_logic::@18
    // stage_bullet_add(flight.xi[e], flight.yi[e], flight.xi[stage.player], flight.yi[stage.player], 4, SIDE_ENEMY, b002)
    // [462] enemy_logic::$51 = *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER) << 1 -- vbuxx=_deref_pbuc1_rol_1 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYER
    asl
    tax
    // [463] enemy_logic::$52 = *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER) << 1 -- vbum1=_deref_pbuc1_rol_1 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYER
    asl
    sta enemy_logic__52
    // [464] stage_bullet_add::sx#1 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[enemy_logic::$41] -- vwum1=pwuc1_derefidx_vbum2 
    ldy enemy_logic__41
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,y
    sta stage_bullet_add.sx
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,y
    sta stage_bullet_add.sx+1
    // [465] stage_bullet_add::sy#1 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[enemy_logic::$41] -- vwum1=pwuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,y
    sta stage_bullet_add.sy
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,y
    sta stage_bullet_add.sy+1
    // [466] stage_bullet_add::tx#1 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[enemy_logic::$51] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    sta stage_bullet_add.tx
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    sta stage_bullet_add.tx+1
    // [467] stage_bullet_add::ty#1 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[enemy_logic::$52] -- vwum1=pwuc1_derefidx_vbum2 
    ldy enemy_logic__52
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,y
    sta stage_bullet_add.ty
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,y
    sta stage_bullet_add.ty+1
    // [468] call stage_bullet_add
    // [799] phi from enemy_logic::@18 to stage_bullet_add [phi:enemy_logic::@18->stage_bullet_add]
    // [799] phi stage_bullet_add::sprite_bullet#2 = $12 [phi:enemy_logic::@18->stage_bullet_add#0] -- vbum1=vbuc1 
    lda #$12
    sta stage_bullet_add.sprite_bullet
    // [799] phi stage_bullet_add::side#2 = 1 [phi:enemy_logic::@18->stage_bullet_add#1] -- vbuxx=vbuc1 
    ldx #1
    // [799] phi stage_bullet_add::speed#2 = 4 [phi:enemy_logic::@18->stage_bullet_add#2] -- vbuyy=vbuc1 
    ldy #4
    // [799] phi stage_bullet_add::ty#2 = stage_bullet_add::ty#1 [phi:enemy_logic::@18->stage_bullet_add#3] -- register_copy 
    // [799] phi stage_bullet_add::tx#2 = stage_bullet_add::tx#1 [phi:enemy_logic::@18->stage_bullet_add#4] -- register_copy 
    // [799] phi stage_bullet_add::sy#2 = stage_bullet_add::sy#1 [phi:enemy_logic::@18->stage_bullet_add#5] -- register_copy 
    // [799] phi stage_bullet_add::sx#2 = stage_bullet_add::sx#1 [phi:enemy_logic::@18->stage_bullet_add#6] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_bullet_add
    .byte >stage_bullet_add
    .byte 3
    // enemy_logic::@14
  __b14:
    // animate_logic(flight.animate[e])
    // [469] animate_logic::a = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta equinoxe_animate.animate_logic.a
    // [470] callexecute animate_logic  -- call_var_near 
    jsr equinoxe_animate.animate_logic
    // collision_insert(e)
    // [471] collision_insert::f#2 = enemy_logic::e#10 -- vbum1=vbum2 
    lda e
    sta collision_insert.f
    // [472] call collision_insert
    // [765] phi from enemy_logic::@14 to collision_insert [phi:enemy_logic::@14->collision_insert]
    // [765] phi collision_insert::f#3 = collision_insert::f#2 [phi:enemy_logic::@14->collision_insert#0] -- register_copy 
    jsr collision_insert
    jmp __b3
    // enemy_logic::@4
  __b4:
    // stage_flightpath_t* enemy_flightpath = flight.flightpath[e]
    // [473] enemy_logic::enemy_flightpath#0 = ((stage_flightpath_t **)&flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH)[enemy_logic::$41] -- pssz1=qssc1_derefidx_vbum2 
    // gotoxy(0, e);
    // printf("%02u - used", e);
    ldy enemy_logic__41
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH,y
    sta.z enemy_flightpath
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH+1,y
    sta.z enemy_flightpath+1
    // unsigned char enemy_action = flight.action[e]
    // [474] enemy_logic::enemy_action#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ACTION)[enemy_logic::e#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ACTION,y
    sta enemy_action
    // stage_action_t* action = stage_get_flightpath_action(enemy_flightpath, enemy_action)
    // [475] stage_get_flightpath_action::flightpath#0 = enemy_logic::enemy_flightpath#0 -- pssz1=pssz2 
    lda.z enemy_flightpath
    sta.z stage_get_flightpath_action.flightpath
    lda.z enemy_flightpath+1
    sta.z stage_get_flightpath_action.flightpath+1
    // [476] stage_get_flightpath_action::action#0 = enemy_logic::enemy_action#0 -- vbuxx=vbum1 
    ldx enemy_action
    // [477] call stage_get_flightpath_action -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_get_flightpath_action
    .byte >stage_get_flightpath_action
    .byte 3
    // [478] stage_get_flightpath_action::return#2 = stage_get_flightpath_action::return#0
    // enemy_logic::@27
    // [479] enemy_logic::action#0 = stage_get_flightpath_action::return#2 -- pssz1=pssz2 
    lda.z stage_get_flightpath_action.return
    sta.z action
    lda.z stage_get_flightpath_action.return+1
    sta.z action+1
    // unsigned char type = stage_get_flightpath_type(enemy_flightpath, enemy_action)
    // [480] stage_get_flightpath_type::flightpath#0 = enemy_logic::enemy_flightpath#0 -- pssz1=pssz2 
    lda.z enemy_flightpath
    sta.z stage_get_flightpath_type.flightpath
    lda.z enemy_flightpath+1
    sta.z stage_get_flightpath_type.flightpath+1
    // [481] stage_get_flightpath_type::action#0 = enemy_logic::enemy_action#0 -- vbuxx=vbum1 
    ldx enemy_action
    // [482] call stage_get_flightpath_type -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_get_flightpath_type
    .byte >stage_get_flightpath_type
    .byte 3
    // [483] stage_get_flightpath_type::return#2 = stage_get_flightpath_type::return#0
    // enemy_logic::@28
    // [484] enemy_logic::type#0 = stage_get_flightpath_type::return#2 -- vbum1=vbuaa 
    sta type
    // unsigned char next = stage_get_flightpath_next(enemy_flightpath, enemy_action)
    // [485] stage_get_flightpath_next::flightpath#0 = enemy_logic::enemy_flightpath#0 -- pssz1=pssz2 
    lda.z enemy_flightpath
    sta.z stage_get_flightpath_next.flightpath
    lda.z enemy_flightpath+1
    sta.z stage_get_flightpath_next.flightpath+1
    // [486] stage_get_flightpath_next::action#0 = enemy_logic::enemy_action#0 -- vbuxx=vbum1 
    ldx enemy_action
    // [487] call stage_get_flightpath_next -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_get_flightpath_next
    .byte >stage_get_flightpath_next
    .byte 3
    // [488] stage_get_flightpath_next::return#2 = stage_get_flightpath_next::return#0
    // enemy_logic::@29
    // [489] enemy_logic::next#0 = stage_get_flightpath_next::return#2 -- vbum1=vbuaa 
    sta next
    // case STAGE_ACTION_MOVE:
    //                     path = stage_get_flightpath_action_move_flight(action);
    //                     turn = stage_get_flightpath_action_move_turn(action);
    //                     speed = stage_get_flightpath_action_move_speed(action);
    //                     // printf("move f=%03u, t=%03d, s=%03u, a=%03u - ", flight, turn, speed, next );
    // 
    // 					enemy_move(e, path, (unsigned char)turn, speed);
    //                     flight.action[e] = next;
    // 					break;
    // [490] if(enemy_logic::type#0==STAGE_ACTION_MOVE) goto enemy_logic::@10 -- vbum1_eq_vbuc1_then_la1 
    lda #STAGE_ACTION_MOVE
    cmp type
    beq __b10
    // enemy_logic::@15
    // case STAGE_ACTION_TURN:
    //                     turn = stage_get_flightpath_action_turn_turn(action);
    //                     radius = stage_get_flightpath_action_turn_radius(action);
    //                     speed = stage_get_flightpath_action_turn_speed(action);
    //                     // printf("turn t=%03d, r=%03u, s=%03u, a=%03u - ", turn, radius, speed, next );
    // 
    // 					enemy_arc( e, (unsigned char)turn, radius, speed);
    //                     flight.action[e] = next;
    // 					break;
    // [491] if(enemy_logic::type#0==STAGE_ACTION_TURN) goto enemy_logic::@11 -- vbum1_eq_vbuc1_then_la1 
    lda #STAGE_ACTION_TURN
    cmp type
    beq __b11
    // enemy_logic::@16
    // case STAGE_ACTION_END:
    //                     stage_enemy_remove(e);
    // 					continue;
    // [492] if(enemy_logic::type#0==STAGE_ACTION_END) goto enemy_logic::@12 -- vbum1_eq_vbuc1_then_la1 
    lda #STAGE_ACTION_END
    cmp type
    beq __b12
    jmp __b9
    // enemy_logic::@12
  __b12:
    // stage_enemy_remove(e)
    // [493] stage_enemy_remove::e#1 = enemy_logic::e#10 -- vbuxx=vbum1 
    ldx e
    // [494] call stage_enemy_remove
    // [843] phi from enemy_logic::@12 to stage_enemy_remove [phi:enemy_logic::@12->stage_enemy_remove]
    // [843] phi stage_enemy_remove::e#2 = stage_enemy_remove::e#1 [phi:enemy_logic::@12->stage_enemy_remove#0] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_enemy_remove
    .byte >stage_enemy_remove
    .byte 3
    jmp __b1
    // enemy_logic::@11
  __b11:
    // stage_get_flightpath_action_turn_turn(action)
    // [495] stage_get_flightpath_action_turn_turn::action_turn#0 = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z stage_get_flightpath_action_turn_turn.action_turn
    lda.z action+1
    sta.z stage_get_flightpath_action_turn_turn.action_turn+1
    // [496] call stage_get_flightpath_action_turn_turn -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_get_flightpath_action_turn_turn
    .byte >stage_get_flightpath_action_turn_turn
    .byte 3
    // [497] stage_get_flightpath_action_turn_turn::return#2 = stage_get_flightpath_action_turn_turn::return#0
    // enemy_logic::@34
    // turn = stage_get_flightpath_action_turn_turn(action)
    // [498] enemy_logic::turn#2 = stage_get_flightpath_action_turn_turn::return#2 -- vbsxx=vbsaa 
    tax
    // stage_get_flightpath_action_turn_radius(action)
    // [499] stage_get_flightpath_action_turn_radius::action_turn#0 = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z stage_get_flightpath_action_turn_radius.action_turn
    lda.z action+1
    sta.z stage_get_flightpath_action_turn_radius.action_turn+1
    // [500] call stage_get_flightpath_action_turn_radius -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_get_flightpath_action_turn_radius
    .byte >stage_get_flightpath_action_turn_radius
    .byte 3
    // [501] stage_get_flightpath_action_turn_radius::return#2 = stage_get_flightpath_action_turn_radius::return#0
    // enemy_logic::@35
    // radius = stage_get_flightpath_action_turn_radius(action)
    // [502] enemy_logic::radius#1 = stage_get_flightpath_action_turn_radius::return#2 -- vbum1=vbuaa 
    sta radius
    // stage_get_flightpath_action_turn_speed(action)
    // [503] stage_get_flightpath_action_turn_speed::action_turn#0 = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z stage_get_flightpath_action_turn_speed.action_turn
    lda.z action+1
    sta.z stage_get_flightpath_action_turn_speed.action_turn+1
    // [504] call stage_get_flightpath_action_turn_speed -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_get_flightpath_action_turn_speed
    .byte >stage_get_flightpath_action_turn_speed
    .byte 3
    // [505] stage_get_flightpath_action_turn_speed::return#2 = stage_get_flightpath_action_turn_speed::return#0
    // enemy_logic::@36
    // speed = stage_get_flightpath_action_turn_speed(action)
    // [506] enemy_logic::speed#2 = stage_get_flightpath_action_turn_speed::return#2 -- vbum1=vbuaa 
    sta speed
    // enemy_arc( e, (unsigned char)turn, radius, speed)
    // [507] enemy_arc::e#0 = enemy_logic::e#10 -- vbuyy=vbum1 
    ldy e
    // [508] enemy_arc::turn#0 = (char)enemy_logic::turn#2
    // [509] enemy_arc::radius#0 = enemy_logic::radius#1 -- vbum1=vbum2 
    lda radius
    sta enemy_arc.radius
    // [510] enemy_arc::speed#0 = enemy_logic::speed#2 -- vbum1=vbum2 
    lda speed
    sta enemy_arc.speed
    // [511] call enemy_arc
    // printf("turn t=%03d, r=%03u, s=%03u, a=%03u - ", turn, radius, speed, next );
    jsr enemy_arc
    // enemy_logic::@37
    // flight.action[e] = next
    // [512] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ACTION)[enemy_logic::e#10] = enemy_logic::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda next
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ACTION,y
    jmp __b9
    // enemy_logic::@10
  __b10:
    // stage_get_flightpath_action_move_flight(action)
    // [513] stage_get_flightpath_action_move_flight::action_move#0 = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z stage_get_flightpath_action_move_flight.action_move
    lda.z action+1
    sta.z stage_get_flightpath_action_move_flight.action_move+1
    // [514] call stage_get_flightpath_action_move_flight -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_get_flightpath_action_move_flight
    .byte >stage_get_flightpath_action_move_flight
    .byte 3
    // [515] stage_get_flightpath_action_move_flight::return#2 = stage_get_flightpath_action_move_flight::return#0
    // enemy_logic::@30
    // path = stage_get_flightpath_action_move_flight(action)
    // [516] enemy_logic::path#1 = stage_get_flightpath_action_move_flight::return#2 -- vwum1=vwum2 
    lda stage_get_flightpath_action_move_flight.return
    sta path
    lda stage_get_flightpath_action_move_flight.return+1
    sta path+1
    // stage_get_flightpath_action_move_turn(action)
    // [517] stage_get_flightpath_action_move_turn::action_move#0 = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z stage_get_flightpath_action_move_turn.action_move
    lda.z action+1
    sta.z stage_get_flightpath_action_move_turn.action_move+1
    // [518] call stage_get_flightpath_action_move_turn -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_get_flightpath_action_move_turn
    .byte >stage_get_flightpath_action_move_turn
    .byte 3
    // [519] stage_get_flightpath_action_move_turn::return#2 = stage_get_flightpath_action_move_turn::return#0
    // enemy_logic::@31
    // turn = stage_get_flightpath_action_move_turn(action)
    // [520] enemy_logic::turn#1 = stage_get_flightpath_action_move_turn::return#2 -- vbsm1=vbsaa 
    sta turn
    // stage_get_flightpath_action_move_speed(action)
    // [521] stage_get_flightpath_action_move_speed::action_move#0 = enemy_logic::action#0 -- pssz1=pssz2 
    lda.z action
    sta.z stage_get_flightpath_action_move_speed.action_move
    lda.z action+1
    sta.z stage_get_flightpath_action_move_speed.action_move+1
    // [522] call stage_get_flightpath_action_move_speed -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <stage_get_flightpath_action_move_speed
    .byte >stage_get_flightpath_action_move_speed
    .byte 3
    // [523] stage_get_flightpath_action_move_speed::return#2 = stage_get_flightpath_action_move_speed::return#0
    // enemy_logic::@32
    // speed = stage_get_flightpath_action_move_speed(action)
    // [524] enemy_logic::speed#1 = stage_get_flightpath_action_move_speed::return#2 -- vbuyy=vbuaa 
    tay
    // enemy_move(e, path, (unsigned char)turn, speed)
    // [525] enemy_move::e#0 = enemy_logic::e#10 -- vbuxx=vbum1 
    ldx e
    // [526] enemy_move::moving#0 = enemy_logic::path#1 -- vwum1=vwum2 
    lda path
    sta enemy_move.moving
    lda path+1
    sta enemy_move.moving+1
    // [527] enemy_move::turn#0 = (char)enemy_logic::turn#1 -- vbum1=vbum2 
    lda turn
    sta enemy_move.turn
    // [528] enemy_move::speed#0 = enemy_logic::speed#1 -- vbum1=vbuyy 
    sty enemy_move.speed
    // [529] call enemy_move
    // printf("move f=%03u, t=%03d, s=%03u, a=%03u - ", flight, turn, speed, next );
    jsr enemy_move
    // enemy_logic::@33
    // flight.action[e] = next
    // [530] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ACTION)[enemy_logic::e#10] = enemy_logic::next#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda next
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ACTION,y
    jmp __b9
  .segment DataEngineEnemies
    enemy_logic__41: .byte 0
    enemy_logic__52: .byte 0
    e: .byte 0
    e_1: .byte 0
    .label enemy_action = enemy_logic__52
    type: .byte 0
    .label next = enemy_logic__52
  .segment Data
    .label math_vecx1_speed = collision_detect.gy
    math_vecx1_dx: .word 0
    .label math_vecy1_speed = collision_detect.gy
    .label math_vecy1_dy = math_vecx1_dx
    .label math_vecx2_speed = collision_detect.gy
    .label math_vecx2_dx = math_vecx1_dx
    .label math_vecy2_speed = collision_detect.gy
    .label math_vecy2_dy = math_vecx1_dx
  .segment DataEngineEnemies
    // printf("efp=%p, ac=%03u, ty=%03u, ne=%03u - ", enemy_flightpath, enemy_action, type, next );
    .label path = r
    .label turn = type
    .label radius = type
    speed: .byte 0
    r: .word 0
}
.segment Code
  // collision_detect
/**
 * @brief Equinoxe main collision detection routine.
 *
 * A spacial grid approach is implemented in the equinoxe gaming engine, to ensure
 * blazing performance during collision detection between all the game objects on the screen.
 *
 * Previously, at each frame, we have executed the during the object logic,
 * the movement calculations and image animations for the screen.
 * As part of this object logic, we have also created a spacial grid, using the collision_insert routines.
 * The grid_ routines uses the routine set ht.h, which is a set of routines to create a has table.
 *
 * This collision_detect detection routine, uses the created spacial grid to efficiently compare the positions of each
 * object relative to each other, and will only compare those objects which have opposite party sides.
 *
 * Each cell in the spacial grid is 64x64 pixels wide in terms of screen dimensions.
 * The dimensions of our screen is 640x480, so there are 10 spacial grid cells on the x axis and 8 spacial grid cells on the y axis.
 * For efficiency reasons to store the spacial grid into memory and to optimize the utilization of the byte architecture of the 6502,
 * we reduced the spacial grid resolution with 2 bits to the right, so we divided by 4 both the x and y coordinates,
 * resulting in the spacial grid dimension to be 160x120. Now the spacial grid has table can
 * be built up using only byte values, not integers. So the x and y coordinate in the spacial grid can now be stored in 4 bits each,
 * where the x coordinate takes the lower nibble of the coordinate byte, and the y coordinate the higher nibble of the coordinate byte.
 *
 * So the spacial grid coordinate system **is stored in a hash table** with the x and y coordinates as the key, which is one byte wide!
 * This results in a very fast calculation algorithm for the 6502, where searching through the has table only requires one byte to be hashed.
 * For further efficiency reasons, the has table implements for duplicate keys a linked list, where the links are stored in a pre-defined
 * array of again only byte sized indexes. Again very efficient for the 6502! the spacial grid uses only absolute addressiing,
 * so pointers are completely avoided, which results in fast processing on the 6502.
 *
 * Because the coordinates in the spacial grid are they in the spacial grid hash table,
 * each object stored in the grid cell will result in a linked list to be built up in the spacial grid hash table!
 * So again very efficient, as now we can take the first element of a spacial grid cell linked list, and iterate through that list to
 * verify each object in that list!
 *
 * The collision detection loops through each cell in the spacial grid. Thus, it will loop horizontally 10 cells and vertically 8 cells.
 * 80 cells in total, however this loop is very efficient as it is only on byte level.
 *
 * During each spacial grid cell evaluation, it performs an outer and an inner loop,
 * where it compares the positions and the properties of the objects in the spacial grid cell against each other
 * using the linked list in the spacial grid hash table.
 *
 * And it does it in a special way, so that no object will be compared twice!
 * The outer loop will loop the complete linked list of the hashed grid cell.
 * The inner loop will only loop from the start position of the outer loop and taking the next element in that list as the start.
 *
 * For example, consider we have in the spacial grid cell the following objects A, B, C, D, E.
 * Then the outer loop will loop from A to E, while the inner loop will take for each element of the outer loop the next starting position.
 * So it will loop as follows:
 *
 *   | LOOP ITERATION | 1       | 2     | 3   | 4 |
 *   | -------------: | :-----: | :---: | :-: | - |
 *   | OUTER LOOP     | A       | B     | C   | D |
 *   | INNER LOOP     | B C D E | C D E | D E | E |
 *
 * This results in the minimal sets of objects to be compared wit? each other, and thus, the most optimizal performance!
 *
 * On top of this comparison the properties of each object are evaluated. Each object as a coalition side,
 * which can be SIDE_FRIENDLY or SIDE_ENEMY. The game setup will only require objects to be compared with different coalitions.
 * So objects of the same coalition are never compared. SIDE_FRIENDLY is never compared with SIDE_FRIENDLY and SIDE_ENEMY is never compared with SIDE_ENEMY.
 *
 * Each object has an AABB or bounding box defined, that contains the dimensions of each object to be taken into account when comparing
 * the bounding box overlap between the objects in the spacial grid cell.
 *
 *
 */
// void collision_detect()
collision_detect: {
    // [532] phi from collision_detect to collision_detect::@1 [phi:collision_detect->collision_detect::@1]
    // [532] phi collision_detect::gy#2 = 0 [phi:collision_detect->collision_detect::@1#0] -- vbum1=vbuc1 
    lda #0
    sta gy
  // The collision key needs the gx and gy so that the key can be calculated using a simple addition.
  // We walk each row on the grid on the y-asis using the gy variable. There are in total 8 rows (480+64)/64.
  // However, we ensure that gy contains the sum of all the cells of each row considered,
  // so gy is incremented with a precision of 16, assuming that each row contains 16 cells.
    // collision_detect::@1
  __b1:
    // for (unsigned char gy = 0; gy < ((480 + 64) >> 2); gy += (64 >> 2))
    // [533] if(collision_detect::gy#2<(char)$1e0+$40>>2) goto collision_detect::@2 -- vbum1_lt_vbuc1_then_la1 
    lda gy
    cmp #$1e0+$40>>2
    bcc __b3
    // collision_detect::@return
    // }
    // [534] return 
    rts
  // we walk each column on the row using the gx variable. Each row has 11 (640+64)/64 cells, (to deal with border collisions too).
  // We consider gx to be incremented for each cell in the column/row combination, so gx is incremented by 1!
    // [535] phi from collision_detect::@1 to collision_detect::@2 [phi:collision_detect::@1->collision_detect::@2]
  __b3:
    // [535] phi collision_detect::gx#10 = 0 [phi:collision_detect::@1->collision_detect::@2#0] -- vbum1=vbuc1 
    lda #0
    sta gx
    // collision_detect::@2
  __b2:
    // for (unsigned char gx = 0; gx < ((640 + 64) >> (2 + 4)); gx += (64 >> (2 + 4)))
    // [536] if(collision_detect::gx#10<(char)$280+$40>>2+4) goto collision_detect::collision_count1 -- vbum1_lt_vbuc1_then_la1 
    lda gx
    cmp #$280+$40>>2+4
    bcc collision_count1
    // collision_detect::@3
    // gy += (64 >> 2)
    // [537] collision_detect::gy#1 = collision_detect::gy#2 + $40>>2 -- vbum1=vbum1_plus_vbuc1 
    lda #$40>>2
    clc
    adc gy
    sta gy
    // [532] phi from collision_detect::@3 to collision_detect::@1 [phi:collision_detect::@3->collision_detect::@1]
    // [532] phi collision_detect::gy#2 = collision_detect::gy#1 [phi:collision_detect::@3->collision_detect::@1#0] -- register_copy 
    jmp __b1
    // collision_detect::collision_count1
  collision_count1:
    // gx + gy
    // [538] collision_detect::collision_count1_$0 = collision_detect::gx#10 + collision_detect::gy#2 -- vbuaa=vbum1_plus_vbum2 
    lda gx
    clc
    adc gy
    // return collision_quadrant.cell[gx + gy];
    // [539] collision_detect::collision_count1_return#0 = ((char *)&collision_quadrant)[collision_detect::collision_count1_$0] -- vbuaa=pbuc1_derefidx_vbuaa 
    tay
    lda collision_quadrant,y
    // collision_detect::@36
    // if (collision_count(gx, gy))
    // [540] if(0==collision_detect::collision_count1_return#0) goto collision_detect::@4 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // collision_detect::@35
    // ht_key_t ht_key_outer = collision_key(gx, gy)
    // [541] collision_key::gx#1 = collision_detect::gx#10 -- vbuaa=vbum1 
    lda gx
    // [542] collision_key::gy#1 = collision_detect::gy#2 -- vbuxx=vbum1 
    ldx gy
    // [543] call collision_key
    // [897] phi from collision_detect::@35 to collision_key [phi:collision_detect::@35->collision_key]
    // [897] phi collision_key::gx#2 = collision_key::gx#1 [phi:collision_detect::@35->collision_key#0] -- register_copy 
    // [897] phi collision_key::gy#2 = collision_key::gy#1 [phi:collision_detect::@35->collision_key#1] -- register_copy 
    jsr collision_key
    // ht_key_t ht_key_outer = collision_key(gx, gy)
    // [544] collision_key::return#3 = collision_key::return#0
    // collision_detect::@40
    // [545] collision_detect::ht_key_outer#0 = collision_key::return#3
    // ht_index_t ht_index_outer = ht_get(&collision_hash, ht_key_outer)
    // [546] ht_get::key#0 = collision_detect::ht_key_outer#0 -- vbum1=vbuaa 
    sta ht_get.key
    // [547] call ht_get
    // [900] phi from collision_detect::@40 to ht_get [phi:collision_detect::@40->ht_get]
    jsr ht_get
    // ht_index_t ht_index_outer = ht_get(&collision_hash, ht_key_outer)
    // [548] ht_get::return#3 = ht_get::return#2
    // collision_detect::@41
    // [549] collision_detect::ht_index_outer#0 = ht_get::return#3 -- vbum1=vbuaa 
    sta ht_index_outer
    // [550] phi from collision_detect::@41 collision_detect::ht_get_next2 to collision_detect::@5 [phi:collision_detect::@41/collision_detect::ht_get_next2->collision_detect::@5]
    // [550] phi collision_detect::ht_index_outer#10 = collision_detect::ht_index_outer#0 [phi:collision_detect::@41/collision_detect::ht_get_next2->collision_detect::@5#0] -- register_copy 
    // collision_detect::@5
  __b5:
    // while (ht_index_outer)
    // [551] if(0!=collision_detect::ht_index_outer#10) goto collision_detect::ht_get_next1 -- 0_neq_vbum1_then_la1 
    lda ht_index_outer
    bne ht_get_next1
    // collision_detect::@4
  __b4:
    // gx += (64 >> (2 + 4))
    // [552] collision_detect::gx#1 = collision_detect::gx#10 + $40>>2+4 -- vbum1=vbum1_plus_vbuc1 
    lda #$40>>2+4
    clc
    adc gx
    sta gx
    // [535] phi from collision_detect::@4 to collision_detect::@2 [phi:collision_detect::@4->collision_detect::@2]
    // [535] phi collision_detect::gx#10 = collision_detect::gx#1 [phi:collision_detect::@4->collision_detect::@2#0] -- register_copy 
    jmp __b2
    // collision_detect::ht_get_next1
  ht_get_next1:
    // return ht_list.next[ht_index];
    // [553] collision_detect::ht_index_inner#0 = ((char *)&ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT)[collision_detect::ht_index_outer#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy ht_index_outer
    lda ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT,y
    sta ht_index_inner
    // collision_detect::@37
    // if (ht_index_inner)
    // [554] if(0==collision_detect::ht_index_inner#0) goto collision_detect::ht_get_next2 -- 0_eq_vbum1_then_la1 
    beq ht_get_next2
    // collision_detect::@34
    // collision_decision_t collision_outer
    // [555] *(&collision_detect::collision_outer) = memset(collision_decision_t, SIZEOF_STRUCT_COLLISION_DECISION_T) -- _deref_pssc1=_memset_vbuc2 
    ldy #SIZEOF_STRUCT_COLLISION_DECISION_T
    lda #0
  !:
    dey
    sta collision_outer,y
    bne !-
    // collision_detect::ht_get_data1
    // return ht_list.data[ht_index];
    // [556] collision_detect::ht_get_data1_return#0 = ((char *)&ht_list)[collision_detect::ht_index_outer#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldy ht_index_outer
    ldx ht_list,y
    // collision_detect::@38
    // collision_data(outer, &collision_outer)
    // [557] collision_data::collision#0 = collision_detect::ht_get_data1_return#0
    // [558] call collision_data
    // [912] phi from collision_detect::@38 to collision_data [phi:collision_detect::@38->collision_data]
    // [912] phi collision_data::collision_decision#2 = &collision_detect::collision_outer [phi:collision_detect::@38->collision_data#0] -- pssz1=pssc1 
    lda #<collision_outer
    sta.z collision_data.collision_decision
    lda #>collision_outer
    sta.z collision_data.collision_decision+1
    // [912] phi collision_data::return#0 = collision_data::collision#0 [phi:collision_detect::@38->collision_data#1] -- register_copy 
    jsr collision_data
    // collision_data(outer, &collision_outer)
    // [559] collision_data::return#2 = collision_data::return#0
    // collision_detect::@42
    // outer = collision_data(outer, &collision_outer)
    // [560] collision_detect::outer#1 = collision_data::return#2 -- vbum1=vbuxx 
    stx outer
    // [561] phi from collision_detect::@42 collision_detect::ht_get_next3 to collision_detect::@6 [phi:collision_detect::@42/collision_detect::ht_get_next3->collision_detect::@6]
    // [561] phi collision_detect::ht_get_next3_ht_index#0 = collision_detect::ht_index_inner#0 [phi:collision_detect::@42/collision_detect::ht_get_next3->collision_detect::@6#0] -- register_copy 
    // collision_detect::@6
  __b6:
    // while (ht_index_inner)
    // [562] if(0!=collision_detect::ht_get_next3_ht_index#0) goto collision_detect::@7 -- 0_neq_vbum1_then_la1 
    lda ht_get_next3_ht_index
    bne __b7
    // collision_detect::ht_get_next2
  ht_get_next2:
    // return ht_list.next[ht_index];
    // [563] collision_detect::ht_get_next2_return#0 = ((char *)&ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT)[collision_detect::ht_index_outer#10] -- vbum1=pbuc1_derefidx_vbum1 
    ldy ht_get_next2_return
    lda ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT,y
    sta ht_get_next2_return
    jmp __b5
    // collision_detect::@7
  __b7:
    // collision_decision_t collision_inner
    // [564] *(&collision_detect::collision_inner) = memset(collision_decision_t, SIZEOF_STRUCT_COLLISION_DECISION_T) -- _deref_pssc1=_memset_vbuc2 
    ldy #SIZEOF_STRUCT_COLLISION_DECISION_T
    lda #0
  !:
    dey
    sta collision_inner,y
    bne !-
    // collision_detect::ht_get_data2
    // return ht_list.data[ht_index];
    // [565] collision_detect::ht_get_data2_return#0 = ((char *)&ht_list)[collision_detect::ht_get_next3_ht_index#0] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy ht_get_next3_ht_index
    lda ht_list,y
    // collision_detect::@39
    // collision_data(inner, &collision_inner)
    // [566] collision_data::collision#1 = collision_detect::ht_get_data2_return#0 -- vbuxx=vbuaa 
    tax
    // [567] call collision_data
    // [912] phi from collision_detect::@39 to collision_data [phi:collision_detect::@39->collision_data]
    // [912] phi collision_data::collision_decision#2 = &collision_detect::collision_inner [phi:collision_detect::@39->collision_data#0] -- pssz1=pssc1 
    lda #<collision_inner
    sta.z collision_data.collision_decision
    lda #>collision_inner
    sta.z collision_data.collision_decision+1
    // [912] phi collision_data::return#0 = collision_data::collision#1 [phi:collision_detect::@39->collision_data#1] -- register_copy 
    jsr collision_data
    // collision_data(inner, &collision_inner)
    // [568] collision_data::return#3 = collision_data::return#0
    // collision_detect::@43
    // inner = collision_data(inner, &collision_inner)
    // [569] collision_detect::inner#1 = collision_data::return#3 -- vbum1=vbuxx 
    stx inner
    // if (collision_outer.side != collision_inner.side)
    // [570] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE)==*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_eq__deref_pbuc2_then_la1 
    lda collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE
    cmp collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE
    bne !ht_get_next3+
    jmp ht_get_next3
  !ht_get_next3:
    // collision_detect::@30
    // if (collision_inner.min_x > collision_outer.max_x || collision_inner.min_y > collision_outer.max_y ||
    //                                     collision_inner.max_x < collision_outer.min_x || collision_inner.max_y < collision_outer.min_y)
    // [571] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X)>*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_gt__deref_pbuc2_then_la1 
    lda collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X
    cmp collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X
    bcs !ht_get_next3+
    jmp ht_get_next3
  !ht_get_next3:
    // collision_detect::@46
    // [572] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y)>*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_gt__deref_pbuc2_then_la1 
    lda collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y
    cmp collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y
    bcs !ht_get_next3+
    jmp ht_get_next3
  !ht_get_next3:
    // collision_detect::@45
    // [573] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X)<*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X
    cmp collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X
    bcs !ht_get_next3+
    jmp ht_get_next3
  !ht_get_next3:
    // collision_detect::@44
    // [574] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y)<*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y
    cmp collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y
    bcc ht_get_next3
    // collision_detect::@31
    // if (collision_outer.side == SIDE_ENEMY)
    // [575] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE)==1) goto collision_detect::@8 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #1
    cmp collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE
    bne !__b8+
    jmp __b8
  !__b8:
    // collision_detect::@32
    // case FLIGHT_BULLET:
    //                                             if (collision_inner.type == FLIGHT_ENEMY) {
    //                                                 collision_detected++;
    //                                             }
    //                                             if (collision_inner.type == FLIGHT_TOWER) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [576] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==3) goto collision_detect::@9 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #3
    cmp collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b9
    // collision_detect::@33
    // case FLIGHT_PLAYER:
    //                                             if (collision_inner.type == FLIGHT_ENEMY) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [577] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==0) goto collision_detect::@10 -- _deref_pbuc1_eq_0_then_la1 
    lda collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b10
    // [578] phi from collision_detect::@10 collision_detect::@16 collision_detect::@18 collision_detect::@27 collision_detect::@33 to collision_detect::@15 [phi:collision_detect::@10/collision_detect::@16/collision_detect::@18/collision_detect::@27/collision_detect::@33->collision_detect::@15]
  __b12:
    // [578] phi collision_detect::collision_detected#11 = 0 [phi:collision_detect::@10/collision_detect::@16/collision_detect::@18/collision_detect::@27/collision_detect::@33->collision_detect::@15#0] -- vbuxx=vbuc1 
    ldx #0
    // [578] phi from collision_detect::@11 collision_detect::@13 collision_detect::@19 collision_detect::@22 to collision_detect::@15 [phi:collision_detect::@11/collision_detect::@13/collision_detect::@19/collision_detect::@22->collision_detect::@15]
    // [578] phi collision_detect::collision_detected#11 = collision_detect::collision_detected#17 [phi:collision_detect::@11/collision_detect::@13/collision_detect::@19/collision_detect::@22->collision_detect::@15#0] -- register_copy 
    // collision_detect::@15
  __b15:
    // if(collision_detected)
    // [579] if(0==collision_detect::collision_detected#11) goto collision_detect::ht_get_next3 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq ht_get_next3
    // collision_detect::@28
    // flight_has_collided(outer)
    // [580] flight_has_collided::f = collision_detect::outer#1 -- vbum1=vbum2 
    lda outer
    sta equinoxe_flightengine.flight_has_collided.f
    // [581] callexecute flight_has_collided  -- call_var_near 
    jsr equinoxe_flightengine.flight_has_collided
    // [582] collision_detect::$37 = flight_has_collided::return -- vbuaa=vbum1 
    lda equinoxe_flightengine.flight_has_collided.return
    // if(!flight_has_collided(outer))
    // [583] if(0!=collision_detect::$37) goto collision_detect::@24 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b24
    // collision_detect::@29
    // stage_impact(outer, inner)
    // [584] stage_impact::f#0 = collision_detect::outer#1 -- vbum1=vbum2 
    lda outer
    sta stage_impact.f
    // [585] stage_impact::h#0 = collision_detect::inner#1 -- vbuaa=vbum1 
    lda inner
    // [586] call stage_impact
    // [933] phi from collision_detect::@29 to stage_impact [phi:collision_detect::@29->stage_impact]
    // [933] phi stage_impact::f#10 = stage_impact::f#0 [phi:collision_detect::@29->stage_impact#0] -- register_copy 
    // [933] phi stage_impact::h#2 = stage_impact::h#0 [phi:collision_detect::@29->stage_impact#1] -- call_phi_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #3
    sta.z 0
    lda.z $ff
    jsr stage_impact
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // collision_detect::@24
  __b24:
    // flight_has_collided(inner)
    // [587] flight_has_collided::f = collision_detect::inner#1 -- vbum1=vbum2 
    lda inner
    sta equinoxe_flightengine.flight_has_collided.f
    // [588] callexecute flight_has_collided  -- call_var_near 
    jsr equinoxe_flightengine.flight_has_collided
    // [589] collision_detect::$41 = flight_has_collided::return -- vbuaa=vbum1 
    lda equinoxe_flightengine.flight_has_collided.return
    // if(!flight_has_collided(inner))
    // [590] if(0!=collision_detect::$41) goto collision_detect::ht_get_next3 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne ht_get_next3
    // collision_detect::@25
    // stage_impact(inner, outer)
    // [591] stage_impact::f#1 = collision_detect::inner#1 -- vbum1=vbum2 
    lda inner
    sta stage_impact.f
    // [592] stage_impact::h#1 = collision_detect::outer#1 -- vbuaa=vbum1 
    lda outer
    // [593] call stage_impact
    // [933] phi from collision_detect::@25 to stage_impact [phi:collision_detect::@25->stage_impact]
    // [933] phi stage_impact::f#10 = stage_impact::f#1 [phi:collision_detect::@25->stage_impact#0] -- register_copy 
    // [933] phi stage_impact::h#2 = stage_impact::h#1 [phi:collision_detect::@25->stage_impact#1] -- call_phi_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #3
    sta.z 0
    lda.z $ff
    jsr stage_impact
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // collision_detect::ht_get_next3
  ht_get_next3:
    // return ht_list.next[ht_index];
    // [594] collision_detect::ht_get_next3_return#0 = ((char *)&ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT)[collision_detect::ht_get_next3_ht_index#0] -- vbum1=pbuc1_derefidx_vbum1 
    ldy ht_get_next3_return
    lda ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT,y
    sta ht_get_next3_return
    jmp __b6
    // collision_detect::@10
  __b10:
    // if (collision_inner.type == FLIGHT_ENEMY)
    // [595] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=1) goto collision_detect::@15 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #1
    cmp collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    bne __b12
    // [596] phi from collision_detect::@10 to collision_detect::@14 [phi:collision_detect::@10->collision_detect::@14]
    // collision_detect::@14
  __b14:
    // [578] phi from collision_detect::@14 collision_detect::@20 collision_detect::@23 to collision_detect::@15 [phi:collision_detect::@14/collision_detect::@20/collision_detect::@23->collision_detect::@15]
    // [578] phi collision_detect::collision_detected#11 = 1 [phi:collision_detect::@14/collision_detect::@20/collision_detect::@23->collision_detect::@15#0] -- vbuxx=vbuc1 
    ldx #1
    jmp __b15
    // collision_detect::@9
  __b9:
    // if (collision_inner.type == FLIGHT_ENEMY)
    // [597] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=1) goto collision_detect::@11 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #1
    cmp collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    bne __b13
    // [598] phi from collision_detect::@9 to collision_detect::@12 [phi:collision_detect::@9->collision_detect::@12]
    // collision_detect::@12
    // [599] phi from collision_detect::@12 to collision_detect::@11 [phi:collision_detect::@12->collision_detect::@11]
    // [599] phi collision_detect::collision_detected#17 = 1 [phi:collision_detect::@12->collision_detect::@11#0] -- vbuxx=vbuc1 
    tax
    jmp __b11
    // [599] phi from collision_detect::@9 to collision_detect::@11 [phi:collision_detect::@9->collision_detect::@11]
  __b13:
    // [599] phi collision_detect::collision_detected#17 = 0 [phi:collision_detect::@9->collision_detect::@11#0] -- vbuxx=vbuc1 
    ldx #0
    // collision_detect::@11
  __b11:
    // if (collision_inner.type == FLIGHT_TOWER)
    // [600] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=2) goto collision_detect::@15 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #2
    cmp collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq !__b15+
    jmp __b15
  !__b15:
    // collision_detect::@13
    // collision_detected++;
    // [601] collision_detect::collision_detected#2 = ++ collision_detect::collision_detected#17 -- vbuxx=_inc_vbuxx 
    inx
    jmp __b15
    // collision_detect::@8
  __b8:
    // case FLIGHT_BULLET:
    //                                             if (collision_inner.type == FLIGHT_PLAYER) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [602] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==3) goto collision_detect::@16 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #3
    cmp collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b16
    // collision_detect::@26
    // case FLIGHT_ENEMY:
    //                                             if (collision_inner.type == FLIGHT_BULLET) {
    //                                                 collision_detected++;
    //                                             }
    //                                             if (collision_inner.type == FLIGHT_PLAYER) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [603] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==1) goto collision_detect::@17 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #1
    cmp collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b17
    // collision_detect::@27
    // case FLIGHT_TOWER:
    //                                             if (collision_inner.type == FLIGHT_BULLET) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [604] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==2) goto collision_detect::@18 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #2
    cmp collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b18
    jmp __b12
    // collision_detect::@18
  __b18:
    // if (collision_inner.type == FLIGHT_BULLET)
    // [605] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=3) goto collision_detect::@15 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #3
    cmp collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq !__b12+
    jmp __b12
  !__b12:
    // [606] phi from collision_detect::@18 to collision_detect::@23 [phi:collision_detect::@18->collision_detect::@23]
    // collision_detect::@23
    jmp __b14
    // collision_detect::@17
  __b17:
    // if (collision_inner.type == FLIGHT_BULLET)
    // [607] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=3) goto collision_detect::@19 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #3
    cmp collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    bne __b20
    // [608] phi from collision_detect::@17 to collision_detect::@21 [phi:collision_detect::@17->collision_detect::@21]
    // collision_detect::@21
    // [609] phi from collision_detect::@21 to collision_detect::@19 [phi:collision_detect::@21->collision_detect::@19]
    // [609] phi collision_detect::collision_detected#14 = 1 [phi:collision_detect::@21->collision_detect::@19#0] -- vbuxx=vbuc1 
    ldx #1
    jmp __b19
    // [609] phi from collision_detect::@17 to collision_detect::@19 [phi:collision_detect::@17->collision_detect::@19]
  __b20:
    // [609] phi collision_detect::collision_detected#14 = 0 [phi:collision_detect::@17->collision_detect::@19#0] -- vbuxx=vbuc1 
    ldx #0
    // collision_detect::@19
  __b19:
    // if (collision_inner.type == FLIGHT_PLAYER)
    // [610] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=0) goto collision_detect::@15 -- _deref_pbuc1_neq_0_then_la1 
    lda collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq !__b15+
    jmp __b15
  !__b15:
    // collision_detect::@22
    // collision_detected++;
    // [611] collision_detect::collision_detected#6 = ++ collision_detect::collision_detected#14 -- vbuxx=_inc_vbuxx 
    inx
    jmp __b15
    // collision_detect::@16
  __b16:
    // if (collision_inner.type == FLIGHT_PLAYER)
    // [612] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=0) goto collision_detect::@15 -- _deref_pbuc1_neq_0_then_la1 
    lda collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq !__b12+
    jmp __b12
  !__b12:
    // [613] phi from collision_detect::@16 to collision_detect::@20 [phi:collision_detect::@16->collision_detect::@20]
    // collision_detect::@20
    jmp __b14
  .segment Data
    collision_outer: .fill SIZEOF_STRUCT_COLLISION_DECISION_T, 0
    collision_inner: .fill SIZEOF_STRUCT_COLLISION_DECISION_T, 0
    gy: .byte 0
    gx: .byte 0
    ht_index_outer: .byte 0
    .label ht_index_inner = ht_get_next3_ht_index
    .label ht_get_next2_return = ht_index_outer
    outer: .byte 0
    inner: .byte 0
    ht_get_next3_ht_index: .byte 0
    .label ht_get_next3_return = ht_get_next3_ht_index
}
.segment Code
  // vera_layer1_hide
/**
 * @brief Hide the layer 1 to be displayed from the screen.
 */
// void vera_layer1_hide()
vera_layer1_hide: {
    // *VERA_CTRL &= ~VERA_DCSEL
    // [614] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER1_ENABLE
    // [615] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER1_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layer1_hide::@return
    // }
    // [616] return 
    rts
}
  // equinoxe_init
// __mem FILE* music;
// unsigned char music_buffer[1024];
// void equinoxe_init()
equinoxe_init: {
    // fload_bram("stages.bin", BANK_ENGINE_STAGES, (bram_ptr_t)0xA000)
    // [618] call fload_bram
    // [954] phi from equinoxe_init to fload_bram [phi:equinoxe_init->fload_bram]
    // [954] phi fload_bram::filename#10 = equinoxe_init::filename [phi:equinoxe_init->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename
    sta.z fload_bram.filename
    lda #>filename
    sta.z fload_bram.filename+1
    // [954] phi fload_bram::dbank#10 = 3 [phi:equinoxe_init->fload_bram#1] -- vbuxx=vbuc1 
    ldx #3
    jsr fload_bram
    // [619] phi from equinoxe_init to equinoxe_init::@1 [phi:equinoxe_init->equinoxe_init::@1]
    // equinoxe_init::@1
    // fload_bram("bramflight1.bin", BANK_ENGINE_SPRITES, (bram_ptr_t)0xA000)
    // [620] call fload_bram
    // [954] phi from equinoxe_init::@1 to fload_bram [phi:equinoxe_init::@1->fload_bram]
    // [954] phi fload_bram::filename#10 = equinoxe_init::filename1 [phi:equinoxe_init::@1->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename1
    sta.z fload_bram.filename
    lda #>filename1
    sta.z fload_bram.filename+1
    // [954] phi fload_bram::dbank#10 = 4 [phi:equinoxe_init::@1->fload_bram#1] -- vbuxx=vbuc1 
    ldx #4
    jsr fload_bram
    // [621] phi from equinoxe_init::@1 to equinoxe_init::@2 [phi:equinoxe_init::@1->equinoxe_init::@2]
    // equinoxe_init::@2
    // fload_bram("bramfloor1.bin", BANK_ENGINE_FLOOR, (bram_ptr_t)0xA000)
    // [622] call fload_bram
    // [954] phi from equinoxe_init::@2 to fload_bram [phi:equinoxe_init::@2->fload_bram]
    // [954] phi fload_bram::filename#10 = equinoxe_init::filename2 [phi:equinoxe_init::@2->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename2
    sta.z fload_bram.filename
    lda #>filename2
    sta.z fload_bram.filename+1
    // [954] phi fload_bram::dbank#10 = 5 [phi:equinoxe_init::@2->fload_bram#1] -- vbuxx=vbuc1 
    ldx #5
    jsr fload_bram
    // [623] phi from equinoxe_init::@2 to equinoxe_init::@3 [phi:equinoxe_init::@2->equinoxe_init::@3]
    // equinoxe_init::@3
    // fload_bram("veraheap.bin", BANK_VERA_HEAP, (bram_ptr_t)0xA000)
    // [624] call fload_bram
    // [954] phi from equinoxe_init::@3 to fload_bram [phi:equinoxe_init::@3->fload_bram]
    // [954] phi fload_bram::filename#10 = equinoxe_init::filename3 [phi:equinoxe_init::@3->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename3
    sta.z fload_bram.filename
    lda #>filename3
    sta.z fload_bram.filename+1
    // [954] phi fload_bram::dbank#10 = 1 [phi:equinoxe_init::@3->fload_bram#1] -- vbuxx=vbuc1 
    ldx #1
    jsr fload_bram
    // [625] phi from equinoxe_init::@3 to equinoxe_init::@4 [phi:equinoxe_init::@3->equinoxe_init::@4]
    // equinoxe_init::@4
    // flight_init()
    // [626] callexecute flight_init  -- call_var_near 
    jsr equinoxe_flightengine.flight_init
    // fload_bram("players.bin", BANK_ENGINE_PLAYERS, (bram_ptr_t)0xA000)
    // [627] call fload_bram
    // [954] phi from equinoxe_init::@4 to fload_bram [phi:equinoxe_init::@4->fload_bram]
    // [954] phi fload_bram::filename#10 = equinoxe_init::filename4 [phi:equinoxe_init::@4->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename4
    sta.z fload_bram.filename
    lda #>filename4
    sta.z fload_bram.filename+1
    // [954] phi fload_bram::dbank#10 = 9 [phi:equinoxe_init::@4->fload_bram#1] -- vbuxx=vbuc1 
    ldx #9
    jsr fload_bram
    // [628] phi from equinoxe_init::@4 to equinoxe_init::@5 [phi:equinoxe_init::@4->equinoxe_init::@5]
    // equinoxe_init::@5
    // fload_bram("enemies.bin", BANK_ENGINE_ENEMIES, (bram_ptr_t)0xA000)
    // [629] call fload_bram
    // [954] phi from equinoxe_init::@5 to fload_bram [phi:equinoxe_init::@5->fload_bram]
    // [954] phi fload_bram::filename#10 = equinoxe_init::filename5 [phi:equinoxe_init::@5->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename5
    sta.z fload_bram.filename
    lda #>filename5
    sta.z fload_bram.filename+1
    // [954] phi fload_bram::dbank#10 = 8 [phi:equinoxe_init::@5->fload_bram#1] -- vbuxx=vbuc1 
    ldx #8
    jsr fload_bram
    // [630] phi from equinoxe_init::@5 to equinoxe_init::@6 [phi:equinoxe_init::@5->equinoxe_init::@6]
    // equinoxe_init::@6
    // fload_bram("bullets.bin", BANK_ENGINE_BULLETS, (bram_ptr_t)0xA000)
    // [631] call fload_bram
    // [954] phi from equinoxe_init::@6 to fload_bram [phi:equinoxe_init::@6->fload_bram]
    // [954] phi fload_bram::filename#10 = equinoxe_init::filename6 [phi:equinoxe_init::@6->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename6
    sta.z fload_bram.filename
    lda #>filename6
    sta.z fload_bram.filename+1
    // [954] phi fload_bram::dbank#10 = 7 [phi:equinoxe_init::@6->fload_bram#1] -- vbuxx=vbuc1 
    ldx #7
    jsr fload_bram
    // [632] phi from equinoxe_init::@6 to equinoxe_init::@7 [phi:equinoxe_init::@6->equinoxe_init::@7]
    // equinoxe_init::@7
    // animate_init()
    // [633] callexecute animate_init  -- call_var_near 
    jsr equinoxe_animate.animate_init
    // memset(&stage, 0, sizeof(stage_t))
    // [634] call memset
    // [974] phi from equinoxe_init::@7 to memset [phi:equinoxe_init::@7->memset]
    jsr memset
    // [635] phi from equinoxe_init::@7 to equinoxe_init::@8 [phi:equinoxe_init::@7->equinoxe_init::@8]
    // equinoxe_init::@8
    // lru_cache_init()
    // [636] callexecute lru_cache_init  -- call_var_near 
    // Initialize the cache in vram for the sprite animations.
    jsr lib_lru_cache.lru_cache_init
    // equinoxe_init::@return
    // }
    // [637] return 
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
    filename5: .text "enemies.bin"
    .byte 0
    filename6: .text "bullets.bin"
    .byte 0
}
.segment CodeEngineStages
  // stage_reset
// void stage_reset()
// __bank(cx16_ram, 3) 
stage_reset: {
    .label stage_player = $3d
    .label stage_engine = $4d
    // palette_init(BANK_ENGINE_PALETTE)
    // [638] palette_init::bram_bank = 6 -- vbum1=vbuc1 
    lda #6
    sta equinoxe_palette.palette_init.bram_bank
    // [639] callexecute palette_init  -- call_var_near 
    jsr equinoxe_palette.palette_init
    // [640] phi from stage_reset to stage_reset::@1 [phi:stage_reset->stage_reset::@1]
    // stage_reset::@1
    // memset(&stage, 0, sizeof(stage_t))
    // [641] call memset
    // [974] phi from stage_reset::@1 to memset [phi:stage_reset::@1->memset]
    jsr memset
    // stage_reset::@2
    // stage.script_b.playbook_total_b = 1
    // [642] *((char *)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B
    // stage.script_b.playbooks_b = stage_playbooks_b
    // [643] *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) = stage_playbooks_b -- _deref_qssc1=pssc2 
    lda #<stage_playbooks_b
    sta stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    lda #>stage_playbooks_b
    sta stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    // &stage_playbooks_b[stage.playbook_current]
    // [644] stage_reset::$17 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_reset__17
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_reset__17+1
    asl stage_reset__17
    rol stage_reset__17+1
    // [645] stage_reset::$18 = stage_reset::$17 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_reset__18
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_reset__18
    lda stage_reset__18+1
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_reset__18+1
    // [646] stage_reset::$10 = stage_reset::$18 << 1 -- vwum1=vwum1_rol_1 
    asl stage_reset__10
    rol stage_reset__10+1
    // [647] memcpy::source#0 = stage_playbooks_b + stage_reset::$10 -- pssz1=pssc1_plus_vwum2 
    lda stage_reset__10
    clc
    adc #<stage_playbooks_b
    sta.z memcpy.source
    lda stage_reset__10+1
    adc #>stage_playbooks_b
    sta.z memcpy.source+1
    // memcpy(&stage.current_playbook, &stage_playbooks_b[stage.playbook_current], sizeof(stage_playbook_t))
    // [648] call memcpy
    // stage.current_playbook = stage_playbook[stage.playbook];
    jsr memcpy
    // stage_reset::@3
    // stage.lives = 10
    // [649] *((char *)&stage+OFFSET_STRUCT_STAGE_T_LIVES) = $a -- _deref_pbuc1=vbuc2 
    lda #$a
    sta stage+OFFSET_STRUCT_STAGE_T_LIVES
    // stage.scenario_total = stage.current_playbook.scenario_total_b
    // [650] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL) = *((char *)(stage_playbook_t *)&stage) -- _deref_pwuc1=_deref_pbuc2 
    lda stage
    sta stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL
    lda #0
    sta stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL+1
    // stage_load()
    // [651] call stage_load
    // bug?
    jsr stage_load
    // stage_reset::@4
    // stage_copy(stage.ew, stage.scenario_current)
    // [652] stage_copy::ew#0 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_EW) -- vbum1=_deref_pwuc1 
    lda stage+OFFSET_STRUCT_STAGE_T_EW
    sta stage_copy.ew
    // [653] stage_copy::scenario#0 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT) -- vwum1=_deref_pwuc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT
    sta stage_copy.scenario
    lda stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT+1
    sta stage_copy.scenario+1
    // [654] call stage_copy
  // Load the artefacts of the stage.
    // [724] phi from stage_reset::@4 to stage_copy [phi:stage_reset::@4->stage_copy]
    // [724] phi stage_copy::ew#2 = stage_copy::ew#0 [phi:stage_reset::@4->stage_copy#0] -- register_copy 
    // [724] phi stage_copy::scenario#2 = stage_copy::scenario#0 [phi:stage_reset::@4->stage_copy#1] -- register_copy 
    jsr stage_copy
    // stage_reset::@5
    // stage_player_t* stage_player = stage_playbooks_b->stage_player
    // [655] stage_reset::stage_player#0 = *((stage_player_t **)stage_playbooks_b+OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER) -- pssz1=_deref_qssc1 
    // Add the player to the stage.
    lda stage_playbooks_b+OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER
    sta.z stage_player
    lda stage_playbooks_b+OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER+1
    sta.z stage_player+1
    // stage_engine_t* stage_engine = stage_player->stage_engine
    // [656] stage_reset::stage_engine#0 = ((stage_engine_t **)stage_reset::stage_player#0)[OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE
    lda (stage_player),y
    sta.z stage_engine
    iny
    lda (stage_player),y
    sta.z stage_engine+1
    // player_add(stage_player->player_sprite, stage_engine->engine_sprite)
    // [657] player_add::sprite_player#0 = *((char *)stage_reset::stage_player#0) -- vbuxx=_deref_pbuz1 
    ldy #0
    lda (stage_player),y
    tax
    // [658] player_add::sprite_engine#0 = *((char *)stage_reset::stage_engine#0) -- vbum1=_deref_pbuz2 
    lda (stage_engine),y
    sta player_add.sprite_engine
    // [659] call player_add
    // [680] phi from stage_reset::@5 to player_add [phi:stage_reset::@5->player_add]
    // [680] phi player_add::sprite_engine#2 = player_add::sprite_engine#0 [phi:stage_reset::@5->player_add#0] -- register_copy 
    // [680] phi player_add::sprite_player#2 = player_add::sprite_player#0 [phi:stage_reset::@5->player_add#1] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <player_add
    .byte >player_add
    .byte 9
    // stage_reset::@return
    // }
    // [660] return 
    rts
  .segment DataEngineStages
    .label stage_reset__10 = stage_load.scenario
    .label stage_reset__17 = stage_load.scenario
    .label stage_reset__18 = stage_load.scenario
}
.segment Code
  // cx16_irq_relay
// void cx16_irq_relay(void (*irq)())
cx16_irq_relay: {
    .label irq = irq_vsync
    // *KERNEL_IRQ = irq
    // [661] *KERNEL_IRQ = cx16_irq_relay::irq#0 -- _deref_qprc1=pprc2 
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // cx16_irq_relay::@return
    // }
    // [662] return 
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
    // [664] return 
    rts
  .segment Data
    visible: .byte 0
    scalex: .byte 0
    scaley: .byte 0
}
.segment Code
  // ht_init
// void ht_init(ht_item_t *ht)
ht_init: {
    .const memset_fast1_ch = 0
    .const memset_fast2_ch = 0
    .label ht = collision_hash
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast1_destination = ht
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast2_destination = ht+OFFSET_STRUCT_HT_ITEM_T_NEXT
    // [666] phi from ht_init to ht_init::memset_fast1 [phi:ht_init->ht_init::memset_fast1]
    // ht_init::memset_fast1
    // [667] phi from ht_init::memset_fast1 to ht_init::memset_fast1_@1 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1]
    // [667] phi ht_init::memset_fast1_num#2 = 0 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [667] phi ht_init::memset_fast1_x#2 = 0 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [667] phi from ht_init::memset_fast1_@1 to ht_init::memset_fast1_@1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1]
    // [667] phi ht_init::memset_fast1_num#2 = ht_init::memset_fast1_num#1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1#0] -- register_copy 
    // [667] phi ht_init::memset_fast1_x#2 = ht_init::memset_fast1_x#1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1#1] -- register_copy 
    // ht_init::memset_fast1_@1
  memset_fast1___b1:
    // destination[x] = ch
    // [668] ht_init::memset_fast1_destination#0[ht_init::memset_fast1_x#2] = ht_init::memset_fast1_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast1_ch
    sta memset_fast1_destination,y
    // x++;
    // [669] ht_init::memset_fast1_x#1 = ++ ht_init::memset_fast1_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [670] ht_init::memset_fast1_num#1 = -- ht_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [671] if(0!=ht_init::memset_fast1_num#1) goto ht_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // [672] phi from ht_init::memset_fast1_@1 to ht_init::memset_fast2 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast2]
    // ht_init::memset_fast2
    // [673] phi from ht_init::memset_fast2 to ht_init::memset_fast2_@1 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1]
    // [673] phi ht_init::memset_fast2_num#2 = 0 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [673] phi ht_init::memset_fast2_x#2 = 0 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [673] phi from ht_init::memset_fast2_@1 to ht_init::memset_fast2_@1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1]
    // [673] phi ht_init::memset_fast2_num#2 = ht_init::memset_fast2_num#1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1#0] -- register_copy 
    // [673] phi ht_init::memset_fast2_x#2 = ht_init::memset_fast2_x#1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1#1] -- register_copy 
    // ht_init::memset_fast2_@1
  memset_fast2___b1:
    // destination[x] = ch
    // [674] ht_init::memset_fast2_destination#0[ht_init::memset_fast2_x#2] = ht_init::memset_fast2_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast2_ch
    sta memset_fast2_destination,y
    // x++;
    // [675] ht_init::memset_fast2_x#1 = ++ ht_init::memset_fast2_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [676] ht_init::memset_fast2_num#1 = -- ht_init::memset_fast2_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [677] if(0!=ht_init::memset_fast2_num#1) goto ht_init::memset_fast2_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast2___b1
    // ht_init::@1
    // ht_list_pool = HT_SIZE-1
    // [678] ht_list_pool = $100-1 -- vbum1=vwuc1 
    lda #<$100-1
    sta ht_list_pool
    // ht_init::@return
    // }
    // [679] return 
    rts
}
.segment CodeEnginePlayers
  // player_add
// void player_add(__register(X) char sprite_player, __mem() char sprite_engine)
// __bank(cx16_ram, 9) 
player_add: {
    // unsigned char p = flight_add(FLIGHT_PLAYER, SIDE_PLAYER, sprite_player)
    // [681] flight_add::type = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_flightengine.flight_add.type
    // [682] flight_add::side = 0 -- vbum1=vbuc1 
    sta equinoxe_flightengine.flight_add.side
    // [683] flight_add::sprite = player_add::sprite_player#2 -- vbum1=vbuxx 
    stx equinoxe_flightengine.flight_add.sprite
    // [684] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [685] player_add::p#0 = flight_add::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_add.return
    sta p
    // flight.moved[p] = 2
    // [686] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVED)[player_add::p#0] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    ldy p
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVED,y
    // flight.firegun[p] = 0
    // [687] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN,y
    // flight.reload[p] = 0
    // [688] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    // flight.health[p] = 100
    // [689] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[player_add::p#0] = $64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #$64
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    // flight.impact[p] = -100
    // [690] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_IMPACT)[player_add::p#0] = -$64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #-$64
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_IMPACT,y
    // animate_add(6,3,3,10,1,0)
    // [691] animate_add::count = 6 -- vbum1=vbuc1 
    lda #6
    sta equinoxe_animate.animate_add.count
    // [692] animate_add::state = 3 -- vbum1=vbuc1 
    lda #3
    sta equinoxe_animate.animate_add.state
    // [693] animate_add::loop = 3 -- vbum1=vbuc1 
    sta equinoxe_animate.animate_add.loop
    // [694] animate_add::speed = $a -- vbum1=vbuc1 
    lda #$a
    sta equinoxe_animate.animate_add.speed
    // [695] animate_add::direction = 1 -- vbsm1=vbsc1 
    lda #1
    sta equinoxe_animate.animate_add.direction
    // [696] animate_add::reverse = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_animate.animate_add.reverse
    // [697] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [698] player_add::$1 = animate_add::return -- vbuaa=vbum1 
    lda equinoxe_animate.animate_add.return
    // flight.animate[p] = animate_add(6,3,3,10,1,0)
    // [699] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_add::p#0] = player_add::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy p
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // flight.xf[p] = 0
    // [700] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_XF)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XF,y
    // flight.yf[p] = 0
    // [701] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_YF)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YF,y
    // flight.xi[p] = 320
    // [702] player_add::$5 = player_add::p#0 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [703] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_add::$5] = $140 -- pwuc1_derefidx_vbuxx=vwuc2 
    lda #<$140
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda #>$140
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[p] = 200
    // [704] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_add::$5] = $c8 -- pwuc1_derefidx_vbuxx=vbuc2 
    lda #$c8
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // flight.xd[p] = 0
    // [705] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[player_add::$5] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,x
    // flight.yd[p] = 0
    // [706] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[player_add::$5] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,x
    // unsigned char n = flight_add(FLIGHT_ENGINE, SIDE_PLAYER, sprite_engine)
    // [707] flight_add::type = 4 -- vbum1=vbuc1 
    lda #4
    sta equinoxe_flightengine.flight_add.type
    // [708] flight_add::side = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_flightengine.flight_add.side
    // [709] flight_add::sprite = player_add::sprite_engine#2 -- vbum1=vbum2 
    lda sprite_engine
    sta equinoxe_flightengine.flight_add.sprite
    // [710] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [711] player_add::n#0 = flight_add::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_add.return
    sta n
    // flight.engine[p] = n
    // [712] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENGINE)[player_add::p#0] = player_add::n#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy p
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENGINE,y
    // animate_add(16,0,0,2,1,0)
    // [713] animate_add::count = $10 -- vbum1=vbuc1 
    lda #$10
    sta equinoxe_animate.animate_add.count
    // [714] animate_add::state = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_animate.animate_add.state
    // [715] animate_add::loop = 0 -- vbum1=vbuc1 
    sta equinoxe_animate.animate_add.loop
    // [716] animate_add::speed = 2 -- vbum1=vbuc1 
    lda #2
    sta equinoxe_animate.animate_add.speed
    // [717] animate_add::direction = 1 -- vbsm1=vbsc1 
    lda #1
    sta equinoxe_animate.animate_add.direction
    // [718] animate_add::reverse = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_animate.animate_add.reverse
    // [719] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [720] player_add::$3 = animate_add::return -- vbuaa=vbum1 
    lda equinoxe_animate.animate_add.return
    // flight.animate[n] = animate_add(16,0,0,2,1,0)
    // [721] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_add::n#0] = player_add::$3 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy n
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // stage.player = p
    // [722] *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER) = player_add::p#0 -- _deref_pbuc1=vbum1 
    lda p
    sta stage+OFFSET_STRUCT_STAGE_T_PLAYER
    // player_add::@return
    // }
    // [723] return 
    rts
  .segment DataEnginePlayers
    p: .byte 0
    n: .byte 0
  .segment Data
    sprite_engine: .byte 0
}
.segment CodeEngineStages
  // stage_copy
// void stage_copy(__mem() char ew, __mem() unsigned int scenario)
// __bank(cx16_ram, 3) 
stage_copy: {
    .label stage_playbook_ptr1_stage_playbooks_b = $3b
    .label stage_playbook_ptr1_return = $3f
    .label stage_scenario_ptr1_stage_scenarios_b = $3b
    .label stage_scenario_ptr1_return = $3f
    .label stage_enemy = $3b
    // stage_copy::stage_playbook_ptr1
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [725] stage_copy::stage_playbook_ptr1_stage_playbooks_b#0 = *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) -- pssz1=_deref_qssc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    sta.z stage_playbook_ptr1_stage_playbooks_b
    lda stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    sta.z stage_playbook_ptr1_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [726] stage_copy::$34 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_copy__34
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_copy__34+1
    asl stage_copy__34
    rol stage_copy__34+1
    // [727] stage_copy::$35 = stage_copy::$34 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_copy__35
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_copy__35
    lda stage_copy__35+1
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_copy__35+1
    // [728] stage_copy::stage_playbook_ptr1_$1 = stage_copy::$35 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr1_stage_copy__1
    rol stage_playbook_ptr1_stage_copy__1+1
    // [729] stage_copy::stage_playbook_ptr1_return#0 = stage_copy::stage_playbook_ptr1_stage_playbooks_b#0 + stage_copy::stage_playbook_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr1_stage_copy__1
    clc
    adc.z stage_playbook_ptr1_stage_playbooks_b
    sta.z stage_playbook_ptr1_return
    lda stage_playbook_ptr1_stage_copy__1+1
    adc.z stage_playbook_ptr1_stage_playbooks_b+1
    sta.z stage_playbook_ptr1_return+1
    // stage_copy::stage_scenario_ptr1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_ptr_b->scenarios_b
    // [730] stage_copy::stage_scenario_ptr1_stage_scenarios_b#0 = ((stage_scenario_t **)stage_copy::stage_playbook_ptr1_return#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b
    iny
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b+1
    // &stage_scenarios_b[scenario]
    // [731] stage_copy::stage_scenario_ptr1_$1 = stage_copy::scenario#2 << 4 -- vwum1=vwum2_rol_4 
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
    // [732] stage_copy::stage_scenario_ptr1_return#0 = stage_copy::stage_scenario_ptr1_stage_scenarios_b#0 + stage_copy::stage_scenario_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_scenario_ptr1_stage_copy__1
    clc
    adc.z stage_scenario_ptr1_stage_scenarios_b
    sta.z stage_scenario_ptr1_return
    lda stage_scenario_ptr1_stage_copy__1+1
    adc.z stage_scenario_ptr1_stage_scenarios_b+1
    sta.z stage_scenario_ptr1_return+1
    // stage_copy::@1
    // wave.x[ew] = stage_scenario_ptr_b->x
    // [733] stage_copy::$4 = stage_copy::ew#2 << 1 -- vbum1=vbum2_rol_1 
    lda ew
    asl
    sta stage_copy__4
    // [734] ((int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_X)[stage_copy::$4] = ((int *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_X] -- pwsc1_derefidx_vbum1=pwsz2_derefidx_vbuc2 
    tax
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_X
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_X,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_X+1,x
    // wave.y[ew] = stage_scenario_ptr_b->y
    // [735] ((int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_Y)[stage_copy::$4] = ((int *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_Y] -- pwsc1_derefidx_vbum1=pwsz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_Y
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_Y,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_Y+1,x
    // wave.enemy_count[ew] = stage_scenario_ptr_b->enemy_count
    // [736] ((char *)&wave)[stage_copy::ew#2] = *((char *)stage_copy::stage_scenario_ptr1_return#0) -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_scenario_ptr1_return),y
    ldy ew
    sta wave,y
    // wave.dx[ew] = stage_scenario_ptr_b->dx
    // [737] ((signed char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_DX)[stage_copy::ew#2] = ((signed char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_DX] -- pbsc1_derefidx_vbum1=pbsz2_derefidx_vbuc2 
    ldx ew
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_DX
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_DX,x
    // wave.dy[ew] = stage_scenario_ptr_b->dy
    // [738] ((signed char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_DY)[stage_copy::ew#2] = ((signed char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_DY] -- pbsc1_derefidx_vbum1=pbsz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_DY
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_DY,x
    // wave.enemy_flightpath[ew] = stage_scenario_ptr_b->enemy_flightpath
    // [739] ((stage_flightpath_t **)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_FLIGHTPATH)[stage_copy::$4] = ((stage_flightpath_t **)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_FLIGHTPATH] -- qssc1_derefidx_vbum1=qssz2_derefidx_vbuc2 
    ldx stage_copy__4
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_FLIGHTPATH
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_FLIGHTPATH,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_FLIGHTPATH+1,x
    // wave.enemy_spawn[ew] = stage_scenario_ptr_b->enemy_spawn
    // [740] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_SPAWN] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldx ew
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_SPAWN
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN,x
    // stage_enemy_t* stage_enemy = stage_scenario_ptr_b->stage_enemy
    // [741] stage_copy::stage_enemy#0 = ((stage_enemy_t **)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY
    lda (stage_scenario_ptr1_return),y
    sta.z stage_enemy
    iny
    lda (stage_scenario_ptr1_return),y
    sta.z stage_enemy+1
    // wave.animation_speed[ew] = stage_enemy->animation_speed
    // [742] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_SPEED)[stage_copy::ew#2] = ((char *)stage_copy::stage_enemy#0)[OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_SPEED] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_SPEED
    lda (stage_enemy),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_SPEED,x
    // wave.animation_reverse[ew] = stage_enemy->animation_reverse
    // [743] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_REVERSE)[stage_copy::ew#2] = ((char *)stage_copy::stage_enemy#0)[OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_REVERSE] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_REVERSE
    lda (stage_enemy),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_REVERSE,x
    // wave.enemy_sprite[ew] = stage_enemy->enemy_sprite_flight
    // [744] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPRITE)[stage_copy::ew#2] = *((char *)stage_copy::stage_enemy#0) -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_enemy),y
    ldy ew
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPRITE,y
    // wave.interval[ew] = stage_scenario_ptr_b->interval
    // [745] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_INTERVAL)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_INTERVAL] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_INTERVAL
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_INTERVAL,x
    // wave.prev[ew] = stage_scenario_ptr_b->prev
    // [746] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_PREV)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_PREV] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_PREV
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_PREV,x
    // wave.wait[ew] = stage_scenario_ptr_b->wait
    // [747] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_WAIT)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_WAIT] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_WAIT
    lda (stage_scenario_ptr1_return),y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_WAIT,x
    // wave.used[ew] = 1
    // [748] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_USED)[stage_copy::ew#2] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy ew
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_USED,y
    // wave.finished[ew] = 0
    // [749] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_FINISHED)[stage_copy::ew#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_FINISHED,y
    // wave.scenario[ew] = scenario
    // [750] ((unsigned int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO)[stage_copy::$4] = stage_copy::scenario#2 -- pwuc1_derefidx_vbum1=vwum2 
    ldy stage_copy__4
    lda scenario
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO,y
    lda scenario+1
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_SCENARIO+1,y
    // wave.enemy_alive[ew] = 0
    // [751] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE)[stage_copy::ew#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy ew
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE,y
    // stage_copy::@return
    // }
    // [752] return 
    rts
  .segment DataEngineStages
    stage_copy__4: .byte 0
    .label stage_playbook_ptr1_stage_copy__1 = stage_logic.stage_logic__54
    .label stage_scenario_ptr1_stage_copy__1 = stage_logic.stage_logic__54
  .segment Data
    .label ew = player_add.sprite_engine
    scenario: .word 0
  .segment DataEngineStages
    .label stage_copy__34 = stage_logic.stage_logic__54
    .label stage_copy__35 = stage_logic.stage_logic__54
}
.segment CodeEngineStages
  // stage_enemy_add
// void stage_enemy_add(__mem() char w, __register(X) char enemy_sprite)
// __bank(cx16_ram, 3) 
stage_enemy_add: {
    // unsigned char enemies = enemy_add(w, enemy_sprite)
    // [753] enemy_add::w#0 = stage_enemy_add::w#0 -- vbum1=vbum2 
    lda w
    sta enemy_add.w
    // [754] enemy_add::sprite_enemy#0 = stage_enemy_add::enemy_sprite#0
    // [755] call enemy_add -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <enemy_add
    .byte >enemy_add
    .byte 8
    // stage_enemy_add::@1
    // wave.x[w] += wave.dx[w]
    // [756] stage_enemy_add::$3 = stage_enemy_add::w#0 << 1 -- vbuxx=vbum1_rol_1 
    lda w
    asl
    tax
    // [757] ((int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_X)[stage_enemy_add::$3] = ((int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_X)[stage_enemy_add::$3] + ((signed char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_DX)[stage_enemy_add::w#0] -- pwsc1_derefidx_vbuxx=pwsc1_derefidx_vbuxx_plus_pbsc2_derefidx_vbum1 
    ldy w
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_DX,y
    sta.z $ff
    clc
    adc wave+OFFSET_STRUCT_STAGE_WAVE_T_X,x
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_X,x
    iny
    lda.z $ff
    ora #$7f
    bmi !+
    lda #0
  !:
    adc wave+OFFSET_STRUCT_STAGE_WAVE_T_X+1,x
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_X+1,x
    // wave.y[w] += wave.dy[w]
    // [758] ((int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_Y)[stage_enemy_add::$3] = ((int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_Y)[stage_enemy_add::$3] + ((signed char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_DY)[stage_enemy_add::w#0] -- pwsc1_derefidx_vbuxx=pwsc1_derefidx_vbuxx_plus_pbsc2_derefidx_vbum1 
    ldy w
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_DY,y
    sta.z $ff
    clc
    adc wave+OFFSET_STRUCT_STAGE_WAVE_T_Y,x
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_Y,x
    iny
    lda.z $ff
    ora #$7f
    bmi !+
    lda #0
  !:
    adc wave+OFFSET_STRUCT_STAGE_WAVE_T_Y+1,x
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_Y+1,x
    // wave.wait[w] = wave.interval[w]
    // [759] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_WAIT)[stage_enemy_add::w#0] = ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_INTERVAL)[stage_enemy_add::w#0] -- pbuc1_derefidx_vbum1=pbuc2_derefidx_vbum1 
    ldy w
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_INTERVAL,y
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_WAIT,y
    // wave.enemy_spawn[w] -= enemies
    // [760] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN)[stage_enemy_add::w#0] = ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN)[stage_enemy_add::w#0] - enemy_add::ret -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_vbuc2 
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN,y
    sec
    sbc #enemy_add.ret
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN,y
    // wave.enemy_count[w] -= enemies
    // [761] ((char *)&wave)[stage_enemy_add::w#0] = ((char *)&wave)[stage_enemy_add::w#0] - enemy_add::ret -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_minus_vbuc2 
    lda wave,y
    sec
    sbc #enemy_add.ret
    sta wave,y
    // wave.enemy_alive[w] += 1
    // [762] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE)[stage_enemy_add::w#0] = ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE)[stage_enemy_add::w#0] + 1 -- pbuc1_derefidx_vbum1=pbuc1_derefidx_vbum1_plus_1 
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE,y
    inc
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE,y
    // stage.enemy_count++;
    // [763] *((char *)&stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT) = ++ *((char *)&stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT
    // stage_enemy_add::@return
    // }
    // [764] return 
    rts
  .segment Data
    w: .byte 0
}
.segment Code
  // collision_insert
/**
 * @brief Add a new coordinate to the spacial grid.
 * This routine is very tricky. It requires to carefully determine which sectors
 * in the spacial grid are to be inserted in the has table.
 * And this is not obvious, sometimes also negative coordinates are given, like -64.
 * This has a risk of ending in an endless loop!
 * So the xmin and ymin are taken as char values, while the xmax and ymax values are taken as int values.
 * This to carefully compare the increment of ymin from 0x00F0 to 0x0100 and not to 0x0000!
 * Same for the xmin value. So the gx and gy values are also int to ensure that the addition is taken in two bytes.
 * But note that only the lower bytes of the int values are actually stored in the spacial grid coordinate system!
 *
 * @param ht
 * @param group
 * @param xmin
 * @param ymin
 * @param f
 */
// void collision_insert(__mem() char f)
collision_insert: {
    // unsigned char xmin = flight.xi[f] >> 2
    // [766] collision_insert::$13 = collision_insert::f#3 << 1 -- vbuxx=vbum1_rol_1 
    lda f
    asl
    tax
    // [767] collision_insert::xmin#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[collision_insert::$13] >> 2 -- vbum1=pwuc1_derefidx_vbuxx_ror_2 
    clc
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    ror
    sta.z $ff
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    ror
    sta.z $fe
    clc
    ror.z $ff
    ror
    sta xmin
    // unsigned char ymin = flight.yi[f] >> 2
    // [768] collision_insert::ymin#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[collision_insert::$13] >> 2 -- vbuxx=pwuc1_derefidx_vbuxx_ror_2 
    clc
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    ror
    sta.z $ff
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    ror
    sta.z $fe
    clc
    ror.z $ff
    ror
    tax
    // flight.cx[f] = xmin
    // [769] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_CX)[collision_insert::f#3] = collision_insert::xmin#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda xmin
    ldy f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_CX,y
    // flight.cy[f] = ymin
    // [770] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_CY)[collision_insert::f#3] = collision_insert::ymin#0 -- pbuc1_derefidx_vbum1=vbuxx 
    txa
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_CY,y
    // flight.collided[f] = 0
    // [771] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[collision_insert::f#3] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // xmin += 16
    // [772] collision_insert::xmin#1 = collision_insert::xmin#0 + $10 -- vbuyy=vbum1_plus_vbuc1 
    // The coordinates start at -63, so we add 16 to avoid negative numbers in the grid key.
    lda #$10
    clc
    adc xmin
    tay
    // ymin += 16
    // [773] collision_insert::ymin#1 = collision_insert::ymin#0 + $10 -- vbum1=vbuxx_plus_vbuc1 
    txa
    clc
    adc #$10
    sta ymin
    // (unsigned char)xmin + 8
    // [774] collision_insert::$2 = collision_insert::xmin#1 + 8 -- vbuaa=vbuyy_plus_vbuc1 
    tya
    clc
    adc #8
    // unsigned char xmax = ((unsigned char)xmin + 8) & 0b11110000
    // [775] collision_insert::xmax#0 = collision_insert::$2 & $f0 -- vbuxx=vbuaa_band_vbuc1 
    and #$f0
    tax
    // (unsigned char)ymin + 8
    // [776] collision_insert::$4 = collision_insert::ymin#1 + 8 -- vbuaa=vbum1_plus_vbuc1 
    lda #8
    clc
    adc ymin
    // unsigned char ymax = ((unsigned char)ymin + 8) & 0b11110000
    // [777] collision_insert::ymax#0 = collision_insert::$4 & $f0 -- vbum1=vbuaa_band_vbuc1 
    and #$f0
    sta ymax
    // xmin >>= 4
    // [778] collision_insert::gx#0 = collision_insert::xmin#1 >> 4 -- vbum1=vbuyy_ror_4 
    tya
    lsr
    lsr
    lsr
    lsr
    sta gx
    // xmax >>= 4
    // [779] collision_insert::xmax#1 = collision_insert::xmax#0 >> 4 -- vbum1=vbuxx_ror_4 
    txa
    lsr
    lsr
    lsr
    lsr
    sta xmax
    // ymin = ymin & 0b11110000
    // [780] collision_insert::ymin#2 = collision_insert::ymin#1 & $f0 -- vbum1=vbum1_band_vbuc1 
    lda #$f0
    and ymin
    sta ymin
    // [781] phi from collision_insert collision_insert::@5 to collision_insert::@1 [phi:collision_insert/collision_insert::@5->collision_insert::@1]
    // [781] phi collision_insert::gx#2 = collision_insert::gx#0 [phi:collision_insert/collision_insert::@5->collision_insert::@1#0] -- register_copy 
    // collision_insert::@1
  __b1:
    // for (unsigned char gx = xmin; gx <= xmax; gx += 1)
    // [782] if(collision_insert::gx#2<=collision_insert::xmax#1) goto collision_insert::@2 -- vbum1_le_vbum2_then_la1 
    lda xmax
    cmp gx
    bcs __b2
    // collision_insert::@return
    // }
    // [783] return 
    rts
    // collision_insert::@2
  __b2:
    // [784] collision_insert::gy#6 = collision_insert::ymin#2 -- vbum1=vbum2 
    lda ymin
    sta gy
    // [785] phi from collision_insert::@2 collision_insert::@7 to collision_insert::@3 [phi:collision_insert::@2/collision_insert::@7->collision_insert::@3]
    // [785] phi collision_insert::gy#2 = collision_insert::gy#6 [phi:collision_insert::@2/collision_insert::@7->collision_insert::@3#0] -- register_copy 
    // collision_insert::@3
  __b3:
    // for (unsigned char gy = ymin; gy <= ymax; gy += 16)
    // [786] if(collision_insert::gy#2<=collision_insert::ymax#0) goto collision_insert::@4 -- vbum1_le_vbum2_then_la1 
    lda ymax
    cmp gy
    bcs __b4
    // collision_insert::@5
    // gx += 1
    // [787] collision_insert::gx#1 = collision_insert::gx#2 + 1 -- vbum1=vbum1_plus_1 
    inc gx
    jmp __b1
    // collision_insert::@4
  __b4:
    // ht_key_t ht_key = collision_key((unsigned char)gx, (unsigned char)gy)
    // [788] collision_key::gx#0 = collision_insert::gx#2 -- vbuaa=vbum1 
    lda gx
    // [789] collision_key::gy#0 = collision_insert::gy#2 -- vbuxx=vbum1 
    ldx gy
    // [790] call collision_key
    // [897] phi from collision_insert::@4 to collision_key [phi:collision_insert::@4->collision_key]
    // [897] phi collision_key::gx#2 = collision_key::gx#0 [phi:collision_insert::@4->collision_key#0] -- register_copy 
    // [897] phi collision_key::gy#2 = collision_key::gy#0 [phi:collision_insert::@4->collision_key#1] -- register_copy 
    jsr collision_key
    // ht_key_t ht_key = collision_key((unsigned char)gx, (unsigned char)gy)
    // [791] collision_key::return#2 = collision_key::return#0
    // collision_insert::@6
    // [792] collision_insert::ht_key#0 = collision_key::return#2
    // ht_insert(&collision_hash, ht_key, f)
    // [793] ht_insert::key#0 = collision_insert::ht_key#0 -- vbum1=vbuaa 
    sta ht_insert.key
    // [794] ht_insert::data#0 = collision_insert::f#3 -- vbum1=vbum2 
    lda f
    sta ht_insert.data
    // [795] call ht_insert
    // [1034] phi from collision_insert::@6 to ht_insert [phi:collision_insert::@6->ht_insert]
    jsr ht_insert
    // collision_insert::@7
    // gy + gx
    // [796] collision_insert::$11 = collision_insert::gy#2 + collision_insert::gx#2 -- vbuaa=vbum1_plus_vbum2 
    lda gy
    clc
    adc gx
    // collision_quadrant.cell[gy + gx] += 1
    // [797] ((char *)&collision_quadrant)[collision_insert::$11] = ((char *)&collision_quadrant)[collision_insert::$11] + 1 -- pbuc1_derefidx_vbuaa=pbuc1_derefidx_vbuaa_plus_1 
    tay
    lda collision_quadrant,y
    inc
    sta collision_quadrant,y
    // gy += 16
    // [798] collision_insert::gy#1 = collision_insert::gy#2 + $10 -- vbum1=vbum1_plus_vbuc1 
    lda #$10
    clc
    adc gy
    sta gy
    jmp __b3
  .segment Data
    .label f = collision_detect.ht_index_outer
    .label xmin = collision_detect.gy
    .label ymin = collision_detect.outer
    .label ymax = collision_detect.inner
    xmax: .byte 0
    .label gx = collision_detect.ht_get_next3_ht_index
    gy: .byte 0
}
.segment CodeEngineStages
  // stage_bullet_add
// void stage_bullet_add(__mem() unsigned int sx, __mem() unsigned int sy, __mem() unsigned int tx, __mem() unsigned int ty, __register(Y) char speed, __register(X) char side, __mem() char sprite_bullet)
// __bank(cx16_ram, 3) 
stage_bullet_add: {
    // bullet_add(sx, sy, tx, ty, speed, side, sprite_bullet)
    // [800] bullet_add::sx#0 = stage_bullet_add::sx#2
    // [801] bullet_add::sy#0 = stage_bullet_add::sy#2
    // [802] bullet_add::tx#0 = stage_bullet_add::tx#2
    // [803] bullet_add::ty#0 = stage_bullet_add::ty#2
    // [804] bullet_add::speed#0 = stage_bullet_add::speed#2 -- vbum1=vbuyy 
    sty bullet_add.speed
    // [805] bullet_add::side#0 = stage_bullet_add::side#2
    // [806] bullet_add::sprite_bullet#0 = stage_bullet_add::sprite_bullet#2 -- vbuyy=vbum1 
    ldy sprite_bullet
    // [807] call bullet_add -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <bullet_add
    .byte >bullet_add
    .byte 7
    // stage_bullet_add::@1
    // stage.bullet_count++;
    // [808] *((char *)&stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT) = ++ *((char *)&stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT
    // stage_bullet_add::@return
    // }
    // [809] return 
    rts
  .segment Data
    .label sx = enemy_logic.math_vecx1_dx
    sy: .word 0
    tx: .word 0
    ty: .word 0
    .label sprite_bullet = collision_detect.gy
}
.segment CodeEngineBullets
  // bullet_remove
// void bullet_remove(__mem() char b)
// __bank(cx16_ram, 7) 
bullet_remove: {
    // if(flight.used[b])
    // [811] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[bullet_remove::b#2]) goto bullet_remove::@return -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy b
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    beq __breturn
    // bullet_remove::@1
    // animate_del(flight.animate[b])
    // [812] animate_del::a = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[bullet_remove::b#2] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta equinoxe_animate.animate_del.a
    // [813] callexecute animate_del  -- call_var_near 
    jsr equinoxe_animate.animate_del
    // flight_remove(FLIGHT_BULLET, b)
    // [814] flight_remove::type = 3 -- vbum1=vbuc1 
    lda #3
    sta equinoxe_flightengine.flight_remove.type
    // [815] flight_remove::f = bullet_remove::b#2 -- vbum1=vbum2 
    lda b
    sta equinoxe_flightengine.flight_remove.f
    // [816] callexecute flight_remove  -- call_var_near 
    jsr equinoxe_flightengine.flight_remove
    // bullet_remove::@return
  __breturn:
    // }
    // [817] return 
    rts
  .segment Data
    .label b = collision_insert.gy
}
.segment Code
  // rand
// Returns a pseudo-random number in the range of 0 to RAND_MAX (65535)
// Uses an xorshift pseudorandom number generator that hits all different values
// Information https://en.wikipedia.org/wiki/Xorshift
// Source http://www.retroprogramming.com/2017/07/xorshift-pseudorandom-numbers-in-z80.html
// __mem() unsigned int rand()
rand: {
    // rand_state << 7
    // [818] rand::$0 = rand_state << 7 -- vwum1=vwum2_rol_7 
    lda rand_state+1
    lsr
    lda rand_state
    ror
    sta rand__0+1
    lda #0
    ror
    sta rand__0
    // rand_state ^= rand_state << 7
    // [819] rand_state = rand_state ^ rand::$0 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__0
    sta rand_state
    lda rand_state+1
    eor rand__0+1
    sta rand_state+1
    // rand_state >> 9
    // [820] rand::$1 = rand_state >> 9 -- vwum1=vwum2_ror_9 
    lsr
    sta rand__1
    lda #0
    sta rand__1+1
    // rand_state ^= rand_state >> 9
    // [821] rand_state = rand_state ^ rand::$1 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__1
    sta rand_state
    lda rand_state+1
    eor rand__1+1
    sta rand_state+1
    // rand_state << 8
    // [822] rand::$2 = rand_state << 8 -- vwum1=vwum2_rol_8 
    lda rand_state
    sta rand__2+1
    lda #0
    sta rand__2
    // rand_state ^= rand_state << 8
    // [823] rand_state = rand_state ^ rand::$2 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__2
    sta rand_state
    lda rand_state+1
    eor rand__2+1
    sta rand_state+1
    // return rand_state;
    // [824] rand::return#0 = rand_state -- vwum1=vwum2 
    lda rand_state
    sta return
    lda rand_state+1
    sta return+1
    // rand::@return
    // }
    // [825] return 
    rts
  .segment Data
    .label rand__0 = enemy_logic.math_vecx1_dx
    .label rand__1 = enemy_logic.math_vecx1_dx
    .label rand__2 = enemy_logic.math_vecx1_dx
    .label return = enemy_logic.math_vecx1_dx
}
.segment CodeEngineStages
  // stage_get_flightpath_action
// __zp($47) stage_action_t * stage_get_flightpath_action(__zp($47) stage_flightpath_t *flightpath, __register(X) char action)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action: {
    .label return = $47
    .label flightpath = $47
    // stage_action_t* flightpath_action = &flightpath[action].action
    // [826] stage_get_flightpath_action::$4 = stage_get_flightpath_action::action#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [827] stage_get_flightpath_action::$5 = stage_get_flightpath_action::$4 + stage_get_flightpath_action::action#0 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [828] stage_get_flightpath_action::$1 = stage_get_flightpath_action::$5 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [829] stage_get_flightpath_action::return#0 = (stage_action_t *)stage_get_flightpath_action::flightpath#0 + stage_get_flightpath_action::$1 -- pssz1=pssz1_plus_vbuaa 
    clc
    adc.z return
    sta.z return
    bcc !+
    inc.z return+1
  !:
    // stage_get_flightpath_action::@return
    // }
    // [830] return 
    rts
}
  // stage_get_flightpath_type
// __register(A) char stage_get_flightpath_type(__zp($47) stage_flightpath_t *flightpath, __register(X) char action)
// __bank(cx16_ram, 3) 
stage_get_flightpath_type: {
    .label stage_get_flightpath_type__1 = $49
    .label flightpath = $47
    // unsigned char type = flightpath[action].type
    // [831] stage_get_flightpath_type::$3 = stage_get_flightpath_type::action#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [832] stage_get_flightpath_type::$4 = stage_get_flightpath_type::$3 + stage_get_flightpath_type::action#0 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [833] stage_get_flightpath_type::$0 = stage_get_flightpath_type::$4 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [834] stage_get_flightpath_type::$1 = (char *)stage_get_flightpath_type::flightpath#0 + OFFSET_STRUCT_STAGE_FLIGHTPATH_T_TYPE -- pbuz1=pbuz2_plus_vbuc1 
    lda #OFFSET_STRUCT_STAGE_FLIGHTPATH_T_TYPE
    clc
    adc.z flightpath
    sta.z stage_get_flightpath_type__1
    lda #0
    adc.z flightpath+1
    sta.z stage_get_flightpath_type__1+1
    // [835] stage_get_flightpath_type::return#0 = stage_get_flightpath_type::$1[stage_get_flightpath_type::$0] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (stage_get_flightpath_type__1),y
    // stage_get_flightpath_type::@return
    // }
    // [836] return 
    rts
}
  // stage_get_flightpath_next
// __register(A) char stage_get_flightpath_next(__zp($47) stage_flightpath_t *flightpath, __register(X) char action)
// __bank(cx16_ram, 3) 
stage_get_flightpath_next: {
    .label stage_get_flightpath_next__1 = $49
    .label flightpath = $47
    // unsigned char next = flightpath[action].next
    // [837] stage_get_flightpath_next::$3 = stage_get_flightpath_next::action#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [838] stage_get_flightpath_next::$4 = stage_get_flightpath_next::$3 + stage_get_flightpath_next::action#0 -- vbuaa=vbuaa_plus_vbuxx 
    stx.z $ff
    clc
    adc.z $ff
    // [839] stage_get_flightpath_next::$0 = stage_get_flightpath_next::$4 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [840] stage_get_flightpath_next::$1 = (char *)stage_get_flightpath_next::flightpath#0 + OFFSET_STRUCT_STAGE_FLIGHTPATH_T_NEXT -- pbuz1=pbuz2_plus_vbuc1 
    lda #OFFSET_STRUCT_STAGE_FLIGHTPATH_T_NEXT
    clc
    adc.z flightpath
    sta.z stage_get_flightpath_next__1
    lda #0
    adc.z flightpath+1
    sta.z stage_get_flightpath_next__1+1
    // [841] stage_get_flightpath_next::return#0 = stage_get_flightpath_next::$1[stage_get_flightpath_next::$0] -- vbuaa=pbuz1_derefidx_vbuxx 
    txa
    tay
    lda (stage_get_flightpath_next__1),y
    // stage_get_flightpath_next::@return
    // }
    // [842] return 
    rts
}
  // stage_enemy_remove
// void stage_enemy_remove(__register(X) char e)
// __bank(cx16_ram, 3) 
stage_enemy_remove: {
    // unsigned char w = enemy_get_wave(e)
    // [844] enemy_get_wave::e#0 = stage_enemy_remove::e#2
    // [845] call enemy_get_wave -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <enemy_get_wave
    .byte >enemy_get_wave
    .byte 8
    // [846] enemy_get_wave::return#0 = enemy_get_wave::return#1
    // stage_enemy_remove::@1
    // [847] stage_enemy_remove::w#0 = enemy_get_wave::return#0 -- vbuyy=vbuaa 
    tay
    // wave.enemy_spawn[w] += 1
    // [848] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN)[stage_enemy_remove::w#0] = ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN)[stage_enemy_remove::w#0] + 1 -- pbuc1_derefidx_vbuyy=pbuc1_derefidx_vbuyy_plus_1 
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN,y
    inc
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_SPAWN,y
    // wave.enemy_alive[w] -= 1
    // [849] ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE)[stage_enemy_remove::w#0] = ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE)[stage_enemy_remove::w#0] - 1 -- pbuc1_derefidx_vbuyy=pbuc1_derefidx_vbuyy_minus_1 
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE,y
    sec
    sbc #1
    sta wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_ALIVE,y
    // enemy_remove(e)
    // [850] enemy_remove::e#0 = stage_enemy_remove::e#2 -- vbum1=vbuxx 
    stx enemy_remove.e
    // [851] call enemy_remove -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <enemy_remove
    .byte >enemy_remove
    .byte 8
    // stage_enemy_remove::@2
    // stage.enemy_count--;
    // [852] *((char *)&stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT) = -- *((char *)&stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT
    // stage_enemy_remove::@return
    // }
    // [853] return 
    rts
}
  // stage_get_flightpath_action_turn_turn
// __register(A) signed char stage_get_flightpath_action_turn_turn(__zp($47) volatile stage_action_t *action_turn)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_turn_turn: {
    .label action_turn = $47
    // return ((stage_action_turn_t*)action_turn)->turn;
    // [854] stage_get_flightpath_action_turn_turn::return#0 = *((signed char *)(stage_action_turn_t *)stage_get_flightpath_action_turn_turn::action_turn#0) -- vbsaa=_deref_pbsz1 
    ldy #0
    lda (action_turn),y
    // stage_get_flightpath_action_turn_turn::@return
    // }
    // [855] return 
    rts
}
  // stage_get_flightpath_action_turn_radius
// __register(A) char stage_get_flightpath_action_turn_radius(__zp($47) stage_action_t *action_turn)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_turn_radius: {
    .label action_turn = $47
    // return ((stage_action_turn_t*)action_turn)->radius;
    // [856] stage_get_flightpath_action_turn_radius::return#0 = ((char *)(stage_action_turn_t *)stage_get_flightpath_action_turn_radius::action_turn#0)[OFFSET_STRUCT_STAGE_ACTION_TURN_T_RADIUS] -- vbuaa=pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_TURN_T_RADIUS
    lda (action_turn),y
    // stage_get_flightpath_action_turn_radius::@return
    // }
    // [857] return 
    rts
}
  // stage_get_flightpath_action_turn_speed
// __register(A) char stage_get_flightpath_action_turn_speed(__zp($47) stage_action_t *action_turn)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_turn_speed: {
    .label action_turn = $47
    // return ((stage_action_turn_t*)action_turn)->speed;
    // [858] stage_get_flightpath_action_turn_speed::return#0 = ((char *)(stage_action_turn_t *)stage_get_flightpath_action_turn_speed::action_turn#0)[OFFSET_STRUCT_STAGE_ACTION_TURN_T_SPEED] -- vbuaa=pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_TURN_T_SPEED
    lda (action_turn),y
    // stage_get_flightpath_action_turn_speed::@return
    // }
    // [859] return 
    rts
}
.segment CodeEngineEnemies
  // enemy_arc
// void enemy_arc(__register(Y) char e, __register(X) char turn, __mem() char radius, __mem() char speed)
// __bank(cx16_ram, 8) 
enemy_arc: {
    // flight.move[e] = 2
    // [860] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_arc::e#0] = 2 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #2
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,y
    // sgn_u8(turn)
    // [861] sgn_u8::b#0 = enemy_arc::turn#0 -- vbuaa=vbuxx 
    txa
    // [862] call sgn_u8
    jsr sgn_u8
    // [863] sgn_u8::return#3 = sgn_u8::return#2
    // enemy_arc::@1
    // [864] enemy_arc::$0 = sgn_u8::return#3
    // flight.turn[e] = sgn_u8(turn)
    // [865] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TURN)[enemy_arc::e#0] = enemy_arc::$0 -- pbuc1_derefidx_vbuyy=vbuaa 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TURN,y
    // flight.radius[e] = radius
    // [866] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RADIUS)[enemy_arc::e#0] = enemy_arc::radius#0 -- pbuc1_derefidx_vbuyy=vbum1 
    lda radius
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RADIUS,y
    // flight.delay[e] = 0
    // [867] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_DELAY)[enemy_arc::e#0] = 0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_DELAY,y
    // abs_u8((unsigned char)turn)
    // [868] abs_u8::b#0 = enemy_arc::turn#0
    // [869] call abs_u8
    jsr abs_u8
    // [870] abs_u8::return#3 = abs_u8::return#2
    // enemy_arc::@2
    // mul8u(abs_u8((unsigned char)turn), radius)
    // [871] mul8u::a#1 = abs_u8::return#3 -- vbuxx=vbuaa 
    tax
    // [872] mul8u::b#0 = enemy_arc::radius#0 -- vbuaa=vbum1 
    lda radius
    // [873] call mul8u
    jsr mul8u
    // [874] mul8u::return#2 = mul8u::res#2
    // enemy_arc::@3
    // [875] enemy_arc::$2 = mul8u::return#2 -- vwum1=vwum2 
    lda mul8u.return
    sta enemy_arc__2
    lda mul8u.return+1
    sta enemy_arc__2+1
    // flight.moving[e] = mul8u(abs_u8((unsigned char)turn), radius)
    // [876] enemy_arc::$3 = enemy_arc::e#0 << 1 -- vbuxx=vbuyy_rol_1 
    tya
    asl
    tax
    // [877] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_arc::$3] = enemy_arc::$2 -- pwuc1_derefidx_vbuxx=vwum1 
    lda enemy_arc__2
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,x
    lda enemy_arc__2+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,x
    // flight.speed[e] = speed
    // [878] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_arc::e#0] = enemy_arc::speed#0 -- pbuc1_derefidx_vbuyy=vbum1 
    lda speed
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    // enemy_arc::@return
    // }
    // [879] return 
    rts
  .segment DataEngineEnemies
    .label enemy_arc__2 = enemy_logic.r
  .segment Data
    .label radius = collision_detect.gy
    .label speed = collision_detect.gx
}
.segment CodeEngineStages
  // stage_get_flightpath_action_move_flight
// __mem() unsigned int stage_get_flightpath_action_move_flight(__zp($47) stage_action_t *action_move)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_move_flight: {
    .label action_move = $47
    // return ((stage_action_move_t*)action_move)->flight;
    // [880] stage_get_flightpath_action_move_flight::return#0 = *((unsigned int *)(stage_action_move_t *)stage_get_flightpath_action_move_flight::action_move#0) -- vwum1=_deref_pwuz2 
    ldy #0
    lda (action_move),y
    sta return
    iny
    lda (action_move),y
    sta return+1
    // stage_get_flightpath_action_move_flight::@return
    // }
    // [881] return 
    rts
  .segment Data
    .label return = enemy_logic.math_vecx1_dx
}
.segment CodeEngineStages
  // stage_get_flightpath_action_move_turn
// __register(A) signed char stage_get_flightpath_action_move_turn(__zp($47) stage_action_t *action_move)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_move_turn: {
    .label action_move = $47
    // return ((stage_action_move_t*)action_move)->turn;
    // [882] stage_get_flightpath_action_move_turn::return#0 = ((signed char *)(stage_action_move_t *)stage_get_flightpath_action_move_turn::action_move#0)[OFFSET_STRUCT_STAGE_ACTION_MOVE_T_TURN] -- vbsaa=pbsz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_MOVE_T_TURN
    lda (action_move),y
    // stage_get_flightpath_action_move_turn::@return
    // }
    // [883] return 
    rts
}
  // stage_get_flightpath_action_move_speed
// __register(A) char stage_get_flightpath_action_move_speed(__zp($47) stage_action_t *action_move)
// __bank(cx16_ram, 3) 
stage_get_flightpath_action_move_speed: {
    .label action_move = $47
    // return ((stage_action_move_t*)action_move)->speed;
    // [884] stage_get_flightpath_action_move_speed::return#0 = ((char *)(stage_action_move_t *)stage_get_flightpath_action_move_speed::action_move#0)[OFFSET_STRUCT_STAGE_ACTION_MOVE_T_SPEED] -- vbuaa=pbuz1_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ACTION_MOVE_T_SPEED
    lda (action_move),y
    // stage_get_flightpath_action_move_speed::@return
    // }
    // [885] return 
    rts
}
.segment CodeEngineEnemies
  // enemy_move
// void enemy_move(__register(X) char e, __mem() unsigned int moving, __mem() char turn, __mem() char speed)
// __bank(cx16_ram, 8) 
enemy_move: {
    // flight.move[e] = 1
    // [886] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVE)[enemy_move::e#0] = 1 -- pbuc1_derefidx_vbuxx=vbuc2 
    lda #1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVE,x
    // if(speed>1)
    // [887] if(enemy_move::speed#0<1+1) goto enemy_move::@1 -- vbum1_lt_vbuc1_then_la1 
    lda speed
    cmp #1+1
    bcc __b1
    // enemy_move::@2
    // speed-1
    // [888] enemy_move::$2 = enemy_move::speed#0 - 1 -- vbuyy=vbum1_minus_1 
    tay
    dey
    // moving >>= (speed-1)
    // [889] enemy_move::moving#1 = enemy_move::moving#0 >> enemy_move::$2 -- vwum1=vwum1_ror_vbuyy 
  !:
    lsr moving+1
    ror moving
    dey
    bne !-
  !e:
    // [890] phi from enemy_move enemy_move::@2 to enemy_move::@1 [phi:enemy_move/enemy_move::@2->enemy_move::@1]
    // [890] phi enemy_move::moving#2 = enemy_move::moving#0 [phi:enemy_move/enemy_move::@2->enemy_move::@1#0] -- register_copy 
    // enemy_move::@1
  __b1:
    // flight.moving[e] = moving
    // [891] enemy_move::$4 = enemy_move::e#0 << 1 -- vbuaa=vbuxx_rol_1 
    txa
    asl
    // [892] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVING)[enemy_move::$4] = enemy_move::moving#2 -- pwuc1_derefidx_vbuaa=vwum1 
    tay
    lda moving
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING,y
    lda moving+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVING+1,y
    // flight.angle[e] + turn
    // [893] enemy_move::$3 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_move::e#0] + enemy_move::turn#0 -- vbuaa=pbuc1_derefidx_vbuxx_plus_vbum1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,x
    clc
    adc turn
    // flight.angle[e] = flight.angle[e] + turn
    // [894] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANGLE)[enemy_move::e#0] = enemy_move::$3 -- pbuc1_derefidx_vbuxx=vbuaa 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANGLE,x
    // flight.speed[e] = speed
    // [895] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[enemy_move::e#0] = enemy_move::speed#0 -- pbuc1_derefidx_vbuxx=vbum1 
    lda speed
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,x
    // enemy_move::@return
    // }
    // [896] return 
    rts
  .segment Data
    .label moving = enemy_logic.math_vecx1_dx
    .label turn = collision_detect.gy
    .label speed = collision_detect.gx
}
.segment Code
  // collision_key
// __register(A) char collision_key(__register(A) char gx, __register(X) char gy)
collision_key: {
    // unsigned char key = gy + gx
    // [898] collision_key::return#0 = collision_key::gy#2 + collision_key::gx#2 -- vbuaa=vbuxx_plus_vbuaa 
    stx.z $ff
    clc
    adc.z $ff
    // collision_key::@return
    // }
    // [899] return 
    rts
}
  // ht_get
// ht_index_t ht_hash_next(ht_index_t index)
// {
//    asm{
//                    lda ht_seed
//                    beq !doEor+
//                    asl
//                    beq !noEor+
//                    bcc !noEor+
//        !doEor:    eor #$2b
//        !noEor:    sta ht_seed
//    }
//    return ht_seed;
// }
// __register(A) char ht_get(ht_item_t *ht, __mem() char key)
ht_get: {
    .label ht = collision_hash
    // [901] phi from ht_get to ht_get::ht_hash1 [phi:ht_get->ht_get::ht_hash1]
    // ht_get::ht_hash1
    // ht_get::@4
    // [902] ht_get::ht_index#6 = ht_get::key#0 -- vbuxx=vbum1 
    ldx key
    // [903] phi from ht_get::@4 ht_get::ht_hash_next1 to ht_get::@1 [phi:ht_get::@4/ht_get::ht_hash_next1->ht_get::@1]
    // [903] phi ht_get::ht_index#2 = ht_get::ht_index#6 [phi:ht_get::@4/ht_get::ht_hash_next1->ht_get::@1#0] -- register_copy 
    // ht_get::@1
  __b1:
    // ht_next = ht->next[ht_index]
    // [904] ht_get::ht_next#1 = ((char *)ht_get::ht#0+OFFSET_STRUCT_HT_ITEM_T_NEXT)[ht_get::ht_index#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda ht+OFFSET_STRUCT_HT_ITEM_T_NEXT,x
    // while ((ht_next = ht->next[ht_index]))
    // [905] if(0!=ht_get::ht_next#1) goto ht_get::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // [906] phi from ht_get::@1 to ht_get::@return [phi:ht_get::@1->ht_get::@return]
    // [906] phi ht_get::return#2 = 0 [phi:ht_get::@1->ht_get::@return#0] -- vbuaa=vbuc1 
    lda #0
    // ht_get::@return
    // }
    // [907] return 
    rts
    // ht_get::@2
  __b2:
    // ht_key = ht->key[ht_index]
    // [908] ht_get::ht_key#1 = ((char *)ht_get::ht#0)[ht_get::ht_index#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda ht,x
    // if ((ht_key = ht->key[ht_index]) == key)
    // [909] if(ht_get::ht_key#1!=ht_get::key#0) goto ht_get::ht_hash_next1 -- vbuaa_neq_vbum1_then_la1 
    cmp key
    bne ht_hash_next1
    // ht_get::@3
    // return ht->next[ht_index];
    // [910] ht_get::return#1 = ((char *)ht_get::ht#0+OFFSET_STRUCT_HT_ITEM_T_NEXT)[ht_get::ht_index#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda ht+OFFSET_STRUCT_HT_ITEM_T_NEXT,x
    // [906] phi from ht_get::@3 to ht_get::@return [phi:ht_get::@3->ht_get::@return]
    // [906] phi ht_get::return#2 = ht_get::return#1 [phi:ht_get::@3->ht_get::@return#0] -- register_copy 
    rts
    // ht_get::ht_hash_next1
  ht_hash_next1:
    // index+1
    // [911] ht_get::ht_hash_next1_return#0 = ht_get::ht_index#2 + 1 -- vbuxx=vbuxx_plus_1 
    inx
    jmp __b1
  .segment Data
    .label key = collision_detect.ht_index_outer
}
.segment Code
  // collision_data
// __register(X) char collision_data(__register(X) char collision, __zp($47) collision_decision_t *collision_decision)
collision_data: {
    .label collision_decision = $47
    // unsigned char type = flight.type[collision]
    // [913] collision_data::type#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[collision_data::return#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,x
    sta type
    // unsigned char side = flight.side[collision]
    // [914] collision_data::side#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SIDE)[collision_data::return#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SIDE,x
    sta side
    // unsigned char x = flight.cx[collision]
    // [915] collision_data::x#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_CX)[collision_data::return#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_CX,x
    sta x
    // unsigned char y = flight.cy[collision]
    // [916] collision_data::y#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_CY)[collision_data::return#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_CY,x
    sta y
    // unsigned char s = flight.cache[collision]
    // [917] collision_data::s#0 = ((char *)&flight)[collision_data::return#0] -- vbum1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight,x
    sta s
    // collision_decision->collision = collision
    // [918] *((char *)collision_data::collision_decision#2) = collision_data::return#0 -- _deref_pbuz1=vbuxx 
    // Which sprite is it in the cache...
    txa
    ldy #0
    sta (collision_decision),y
    // collision_decision->s = s
    // [919] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_S] = collision_data::s#0 -- pbuz1_derefidx_vbuc1=vbum2 
    lda s
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_S
    sta (collision_decision),y
    // collision_decision->x = x
    // [920] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_X] = collision_data::x#0 -- pbuz1_derefidx_vbuc1=vbum2 
    lda x
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_X
    sta (collision_decision),y
    // collision_decision->y = y
    // [921] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_Y] = collision_data::y#0 -- pbuz1_derefidx_vbuc1=vbum2 
    lda y
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_Y
    sta (collision_decision),y
    // collision_decision->side = side
    // [922] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_SIDE] = collision_data::side#0 -- pbuz1_derefidx_vbuc1=vbum2 
    lda side
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_SIDE
    sta (collision_decision),y
    // collision_decision->type = type
    // [923] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_TYPE] = collision_data::type#0 -- pbuz1_derefidx_vbuc1=vbum2 
    lda type
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    sta (collision_decision),y
    // x + sprite_cache.xmin[s]
    // [924] collision_data::$0 = collision_data::x#0 + ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN)[collision_data::s#0] -- vbuaa=vbum1_plus_pbuc1_derefidx_vbum2 
    lda x
    ldy s
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN,y
    // collision_decision->min_x = x + sprite_cache.xmin[s]
    // [925] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X] = collision_data::$0 -- pbuz1_derefidx_vbuc1=vbuaa 
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X
    sta (collision_decision),y
    // y + sprite_cache.ymin[s]
    // [926] collision_data::$1 = collision_data::y#0 + ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN)[collision_data::s#0] -- vbuaa=vbum1_plus_pbuc1_derefidx_vbum2 
    lda y
    ldy s
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN,y
    // collision_decision->min_y = y + sprite_cache.ymin[s]
    // [927] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y] = collision_data::$1 -- pbuz1_derefidx_vbuc1=vbuaa 
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y
    sta (collision_decision),y
    // x + sprite_cache.xmax[s]
    // [928] collision_data::$2 = collision_data::x#0 + ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX)[collision_data::s#0] -- vbuaa=vbum1_plus_pbuc1_derefidx_vbum2 
    lda x
    ldy s
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX,y
    // collision_decision->max_x = x + sprite_cache.xmax[s]
    // [929] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X] = collision_data::$2 -- pbuz1_derefidx_vbuc1=vbuaa 
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X
    sta (collision_decision),y
    // y + sprite_cache.ymax[s]
    // [930] collision_data::$3 = collision_data::y#0 + ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX)[collision_data::s#0] -- vbuaa=vbum1_plus_pbuc1_derefidx_vbum2 
    lda y
    ldy s
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX,y
    // collision_decision->max_y = y + sprite_cache.ymax[s]
    // [931] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y] = collision_data::$3 -- pbuz1_derefidx_vbuc1=vbuaa 
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y
    sta (collision_decision),y
    // collision_data::@return
    // }
    // [932] return 
    rts
  .segment Data
    .label type = collision_insert.gy
    .label side = collision_detect.inner
    .label x = collision_insert.xmax
    y: .byte 0
    s: .byte 0
}
.segment CodeEngineStages
  // stage_impact
// void stage_impact(__mem() char f, __register(A) char h)
// __bank(cx16_ram, 3) 
stage_impact: {
    // flight_impact(h)
    // [934] flight_impact::f = stage_impact::h#2 -- vbum1=vbuaa 
    sta equinoxe_flightengine.flight_impact.f
    // [935] callexecute flight_impact  -- call_var_near 
    jsr equinoxe_flightengine.flight_impact
    // [936] stage_impact::$0 = flight_impact::return -- vbsxx=vbsm1 
    ldx equinoxe_flightengine.flight_impact.return
    // signed char hit = flight_hit(f, flight_impact(h))
    // [937] flight_hit::f = stage_impact::f#10 -- vbum1=vbum2 
    lda f
    sta equinoxe_flightengine.flight_hit.f
    // [938] flight_hit::impact = stage_impact::$0 -- vbsm1=vbsxx 
    stx equinoxe_flightengine.flight_hit.impact
    // [939] callexecute flight_hit  -- call_var_near 
    jsr equinoxe_flightengine.flight_hit
    // [940] stage_impact::hit#0 = flight_hit::return -- vbsaa=vbsm1 
    lda equinoxe_flightengine.flight_hit.return
    // if(hit)
    // [941] if(0==stage_impact::hit#0) goto stage_impact::@return -- 0_eq_vbsaa_then_la1 
    cmp #0
    beq __b8
    // stage_impact::@1
    // case FLIGHT_ENEMY:
    //                 stage_enemy_remove(f);
    //                 break;
    // [942] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[stage_impact::f#10]==1) goto stage_impact::@5 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    ldy f
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #1
    beq __b5
    // stage_impact::@2
    // case FLIGHT_BULLET:
    //                 stage_bullet_remove(f);
    //                 break;
    // [943] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[stage_impact::f#10]==3) goto stage_impact::@6 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #3
    beq __b6
    // stage_impact::@3
    // case FLIGHT_PLAYER:
    //                 stage_player_remove(f);
    //                 break;
    // [944] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[stage_impact::f#10]==0) goto stage_impact::@7 -- pbuc1_derefidx_vbum1_eq_0_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #0
    beq __b7
    // stage_impact::@4
    // case FLIGHT_TOWER:
    //                 stage_tower_remove(f);
    //                 break;
    // [945] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[stage_impact::f#10]==2) goto stage_impact::@8 -- pbuc1_derefidx_vbum1_eq_vbuc2_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #2
    beq __b8
    rts
    // [946] phi from stage_impact::@4 to stage_impact::@8 [phi:stage_impact::@4->stage_impact::@8]
    // stage_impact::@8
  __b8:
    // stage_impact::@return
    // }
    // [947] return 
    rts
    // stage_impact::@7
  __b7:
    // stage_player_remove(f)
    // [948] stage_player_remove::p#0 = stage_impact::f#10 -- vbuaa=vbum1 
    lda f
    // [949] call stage_player_remove
    jsr stage_player_remove
    rts
    // stage_impact::@6
  __b6:
    // stage_bullet_remove(f)
    // [950] stage_bullet_remove::b#0 = stage_impact::f#10 -- vbuaa=vbum1 
    lda f
    // [951] call stage_bullet_remove
    jsr stage_bullet_remove
    rts
    // stage_impact::@5
  __b5:
    // stage_enemy_remove(f)
    // [952] stage_enemy_remove::e#0 = stage_impact::f#10 -- vbuxx=vbum1 
    ldx f
    // [953] call stage_enemy_remove
    // [843] phi from stage_impact::@5 to stage_enemy_remove [phi:stage_impact::@5->stage_enemy_remove]
    // [843] phi stage_enemy_remove::e#2 = stage_enemy_remove::e#0 [phi:stage_impact::@5->stage_enemy_remove#0] -- register_copy 
    jsr stage_enemy_remove
    rts
  .segment Data
    .label f = collision_insert.gy
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
// unsigned int fload_bram(__zp($43) char *filename, __register(X) char dbank, char *dptr)
fload_bram: {
    .label fp = $45
    .label filename = $43
    // fload_bram::bank_get_bram1
    // return BRAM;
    // [955] fload_bram::bank_set_bram2_bank#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_set_bram2_bank
    // fload_bram::bank_set_bram1
    // BRAM = bank
    // [956] BRAM = fload_bram::dbank#10 -- vbuz1=vbuxx 
    stx.z BRAM
    // fload_bram::@4
    // FILE* fp = fopen(filename,"r")
    // [957] fopen::path = fload_bram::filename#10 -- pbuz1=pbuz2 
    lda.z filename
    sta.z lib_file.fopen.path
    lda.z filename+1
    sta.z lib_file.fopen.path+1
    // [958] fopen::mode = fload_bram::mode -- pbuz1=pbuc1 
    lda #<mode
    sta.z lib_file.fopen.mode
    lda #>mode
    sta.z lib_file.fopen.mode+1
    // [959] callexecute fopen  -- call_var_near 
    jsr lib_file.fopen
    // [960] fload_bram::fp#0 = fopen::return -- pssz1=pssz2 
    lda.z lib_file.fopen.return
    sta.z fp
    lda.z lib_file.fopen.return+1
    sta.z fp+1
    // if(fp)
    // [961] if((struct file_handle_s *)0==fload_bram::fp#0) goto fload_bram::bank_set_bram2 -- pssc1_eq_pssz1_then_la1 
    lda.z fp
    cmp #<0
    bne !+
    lda.z fp+1
    cmp #>0
    beq bank_set_bram2
  !:
    // fload_bram::@1
    // fgets(dptr, 0, fp)
    // [962] fgets::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_file.fgets.ptr
    lda #>$a000
    sta.z lib_file.fgets.ptr+1
    // [963] fgets::size = 0 -- vwum1=vbuc1 
    lda #<0
    sta lib_file.fgets.size
    sta lib_file.fgets.size+1
    // [964] fgets::stream = fload_bram::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fgets.stream
    lda.z fp+1
    sta.z lib_file.fgets.stream+1
    // [965] callexecute fgets  -- call_var_near 
    jsr lib_file.fgets
    // read = fgets(dptr, 0, fp)
    // [966] fload_bram::read#1 = fgets::return -- vwum1=vwum2 
    lda lib_file.fgets.return
    sta read
    lda lib_file.fgets.return+1
    sta read+1
    // if(read)
    // [967] if(0!=fload_bram::read#1) goto fload_bram::@3 -- 0_neq_vwum1_then_la1 
    lda read
    ora read+1
    bne __b3
    // fload_bram::@2
    // fclose(fp)
    // [968] fclose::stream = fload_bram::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fclose.stream
    lda.z fp+1
    sta.z lib_file.fclose.stream+1
    // [969] callexecute fclose  -- call_var_near 
    jsr lib_file.fclose
    // fload_bram::bank_set_bram2
  bank_set_bram2:
    // BRAM = bank
    // [970] BRAM = fload_bram::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // fload_bram::@return
    // }
    // [971] return 
    rts
    // fload_bram::@3
  __b3:
    // fclose(fp)
    // [972] fclose::stream = fload_bram::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fclose.stream
    lda.z fp+1
    sta.z lib_file.fclose.stream+1
    // [973] callexecute fclose  -- call_var_near 
    jsr lib_file.fclose
    jmp bank_set_bram2
  .segment Data
    mode: .text "r"
    .byte 0
    bank_set_bram2_bank: .byte 0
    read: .word 0
}
.segment Code
  // memset
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .label end = stage+SIZEOF_STRUCT_STAGE_T
    .label dst = $43
    // [975] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [975] phi memset::dst#2 = (char *)(void *)&stage [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<stage
    sta.z dst
    lda #>stage
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [976] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [977] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [978] *memset::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [979] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [975] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [975] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
  // memcpy
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(void *destination, __zp($45) volatile stage_playbook_t *source, unsigned int num)
memcpy: {
    .label destination = stage
    .label src_end = $4b
    .label dst = $43
    .label src = $45
    .label source = $45
    // char* src_end = (char*)source+num
    // [980] memcpy::src_end#0 = (char *)(void *)memcpy::source#0 + SIZEOF_STRUCT_STAGE_PLAYBOOK_T -- pbuz1=pbuz2_plus_vbuc1 
    lda #SIZEOF_STRUCT_STAGE_PLAYBOOK_T
    clc
    adc.z source
    sta.z src_end
    lda #0
    adc.z source+1
    sta.z src_end+1
    // [981] memcpy::src#4 = (char *)(void *)memcpy::source#0
    // [982] phi from memcpy to memcpy::@1 [phi:memcpy->memcpy::@1]
    // [982] phi memcpy::dst#2 = (char *)memcpy::destination#0 [phi:memcpy->memcpy::@1#0] -- pbuz1=pbuc1 
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    // [982] phi memcpy::src#2 = memcpy::src#4 [phi:memcpy->memcpy::@1#1] -- register_copy 
    // memcpy::@1
  __b1:
    // while(src!=src_end)
    // [983] if(memcpy::src#2!=memcpy::src_end#0) goto memcpy::@2 -- pbuz1_neq_pbuz2_then_la1 
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    // memcpy::@return
    // }
    // [984] return 
    rts
    // memcpy::@2
  __b2:
    // *dst++ = *src++
    // [985] *memcpy::dst#2 = *memcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [986] memcpy::dst#1 = ++ memcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [987] memcpy::src#1 = ++ memcpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [982] phi from memcpy::@2 to memcpy::@1 [phi:memcpy::@2->memcpy::@1]
    // [982] phi memcpy::dst#2 = memcpy::dst#1 [phi:memcpy::@2->memcpy::@1#0] -- register_copy 
    // [982] phi memcpy::src#2 = memcpy::src#1 [phi:memcpy::@2->memcpy::@1#1] -- register_copy 
    jmp __b1
}
.segment CodeEngineStages
  // stage_load
// void stage_load()
// __bank(cx16_ram, 3) 
stage_load: {
    .label stage_playbooks_b = $3d
    .label stage_playbook_b = $3d
    .label stage_scenarios_b = $4d
    .label stage_scenario = $3d
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [988] stage_load::stage_playbooks_b#0 = *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) -- pssz1=_deref_qssc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    sta.z stage_playbooks_b
    lda stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    sta.z stage_playbooks_b+1
    // stage_playbook_t* stage_playbook_b = &stage_playbooks_b[stage.playbook_current]
    // [989] stage_load::$15 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_load__15
    lda stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_load__15+1
    asl stage_load__15
    rol stage_load__15+1
    // [990] stage_load::$16 = stage_load::$15 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_load__16
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_load__16
    lda stage_load__16+1
    adc stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_load__16+1
    // [991] stage_load::$5 = stage_load::$16 << 1 -- vwum1=vwum1_rol_1 
    asl stage_load__5
    rol stage_load__5+1
    // [992] stage_load::stage_playbook_b#0 = stage_load::stage_playbooks_b#0 + stage_load::$5 -- pssz1=pssz1_plus_vwum2 
    clc
    lda.z stage_playbook_b
    adc stage_load__5
    sta.z stage_playbook_b
    lda.z stage_playbook_b+1
    adc stage_load__5+1
    sta.z stage_playbook_b+1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_b->scenarios_b
    // [993] stage_load::stage_scenarios_b#0 = ((stage_scenario_t **)stage_load::stage_playbook_b#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B
    lda (stage_playbook_b),y
    sta.z stage_scenarios_b
    iny
    lda (stage_playbook_b),y
    sta.z stage_scenarios_b+1
    // unsigned int stage_scenario_total = stage_playbook_b->scenario_total_b
    // [994] stage_load::stage_scenario_total#0 = (unsigned int)*((char *)stage_load::stage_playbook_b#0) -- vwum1=_word__deref_pbuz2 
    ldy #0
    lda (stage_playbook_b),y
    sta stage_scenario_total
    tya
    sta stage_scenario_total+1
    // stage_load_player(stage_playbook_b->stage_player)
    // [995] stage_load_player::stage_player#0 = ((stage_player_t **)stage_load::stage_playbook_b#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER
    lda (stage_playbook_b),y
    sta.z stage_load_player.stage_player
    iny
    lda (stage_playbook_b),y
    sta.z stage_load_player.stage_player+1
    // [996] call stage_load_player
    jsr stage_load_player
    // [997] phi from stage_load to stage_load::@1 [phi:stage_load->stage_load::@1]
    // [997] phi stage_load::scenario#2 = 0 [phi:stage_load->stage_load::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta scenario
    sta scenario+1
  // Loading the enemy sprites in bram.
    // stage_load::@1
  __b1:
    // for(unsigned int scenario = 0; scenario < stage_scenario_total; scenario++)
    // [998] if(stage_load::scenario#2<stage_load::stage_scenario_total#0) goto stage_load::@2 -- vwum1_lt_vwum2_then_la1 
    lda scenario+1
    cmp stage_scenario_total+1
    bcc __b2
    bne !+
    lda scenario
    cmp stage_scenario_total
    bcc __b2
  !:
    // stage_load::@return
    // }
    // [999] return 
    rts
    // stage_load::@2
  __b2:
    // stage_scenario_t* stage_scenario = &stage_scenarios_b[scenario]
    // [1000] stage_load::$6 = stage_load::scenario#2 << 4 -- vwum1=vwum2_rol_4 
    lda scenario
    asl
    sta stage_load__6
    lda scenario+1
    rol
    sta stage_load__6+1
    asl stage_load__6
    rol stage_load__6+1
    asl stage_load__6
    rol stage_load__6+1
    asl stage_load__6
    rol stage_load__6+1
    // [1001] stage_load::stage_scenario#0 = stage_load::stage_scenarios_b#0 + stage_load::$6 -- pssz1=pssz2_plus_vwum3 
    lda stage_load__6
    clc
    adc.z stage_scenarios_b
    sta.z stage_scenario
    lda stage_load__6+1
    adc.z stage_scenarios_b+1
    sta.z stage_scenario+1
    // stage_load_enemy(stage_scenario->stage_enemy)
    // [1002] stage_load_enemy::stage_enemy#0 = ((stage_enemy_t **)stage_load::stage_scenario#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY
    lda (stage_scenario),y
    sta.z stage_load_enemy.stage_enemy
    iny
    lda (stage_scenario),y
    sta.z stage_load_enemy.stage_enemy+1
    // [1003] call stage_load_enemy
    jsr stage_load_enemy
    // stage_load::@3
    // for(unsigned int scenario = 0; scenario < stage_scenario_total; scenario++)
    // [1004] stage_load::scenario#1 = ++ stage_load::scenario#2 -- vwum1=_inc_vwum1 
    inc scenario
    bne !+
    inc scenario+1
  !:
    // [997] phi from stage_load::@3 to stage_load::@1 [phi:stage_load::@3->stage_load::@1]
    // [997] phi stage_load::scenario#2 = stage_load::scenario#1 [phi:stage_load::@3->stage_load::@1#0] -- register_copy 
    jmp __b1
  .segment DataEngineStages
    .label stage_load__5 = scenario
    stage_load__6: .word 0
    stage_scenario_total: .word 0
    scenario: .word 0
    .label stage_load__15 = scenario
    .label stage_load__16 = scenario
}
.segment CodeEngineEnemies
  // enemy_add
// char enemy_add(__mem() char w, __register(X) char sprite_enemy)
// __bank(cx16_ram, 8) 
enemy_add: {
    .label ret = 1
    .label flightpath = $41
    // unsigned char e = flight_add(FLIGHT_ENEMY, SIDE_ENEMY, sprite_enemy)
    // [1005] flight_add::type = 1 -- vbum1=vbuc1 
    lda #1
    sta equinoxe_flightengine.flight_add.type
    // [1006] flight_add::side = 1 -- vbum1=vbuc1 
    sta equinoxe_flightengine.flight_add.side
    // [1007] flight_add::sprite = enemy_add::sprite_enemy#0 -- vbum1=vbuxx 
    stx equinoxe_flightengine.flight_add.sprite
    // [1008] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [1009] enemy_add::e#0 = flight_add::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_add.return
    sta e
    // flight.wave[e] = w
    // [1010] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_WAVE)[enemy_add::e#0] = enemy_add::w#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda w
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_WAVE,y
    // sprite_cache.count[flight.cache[e]]-1
    // [1011] enemy_add::$1 = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT)[((char *)&flight)[enemy_add::e#0]] - 1 -- vbuxx=pbuc1_derefidx_(pbuc2_derefidx_vbum1)_minus_1 
    ldx e
    ldy equinoxe_flightengine.flight,x
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT,y
    dex
    // animate_add(
    // 		sprite_cache.count[flight.cache[e]]-1, 
    // 		0,
    // 		0,
    // 		wave.animation_speed[w],
    // 		1, 
    // 		wave.animation_reverse[w]
    // 		)
    // [1012] animate_add::count = enemy_add::$1 -- vbum1=vbuxx 
    stx equinoxe_animate.animate_add.count
    // [1013] animate_add::state = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_animate.animate_add.state
    // [1014] animate_add::loop = 0 -- vbum1=vbuc1 
    sta equinoxe_animate.animate_add.loop
    // [1015] animate_add::speed = ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_SPEED)[enemy_add::w#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy w
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_SPEED,y
    sta equinoxe_animate.animate_add.speed
    // [1016] animate_add::direction = 1 -- vbsm1=vbsc1 
    lda #1
    sta equinoxe_animate.animate_add.direction
    // [1017] animate_add::reverse = ((char *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_REVERSE)[enemy_add::w#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ANIMATION_REVERSE,y
    sta equinoxe_animate.animate_add.reverse
    // [1018] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [1019] enemy_add::$2 = animate_add::return -- vbuaa=vbum1 
    lda equinoxe_animate.animate_add.return
    // flight.animate[e] = animate_add(
    // 		sprite_cache.count[flight.cache[e]]-1, 
    // 		0,
    // 		0,
    // 		wave.animation_speed[w],
    // 		1, 
    // 		wave.animation_reverse[w]
    // 		)
    // [1020] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[enemy_add::e#0] = enemy_add::$2 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // flight.health[e] = 100
    // [1021] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[enemy_add::e#0] = $64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #$64
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    // flight.impact[e] = -30
    // [1022] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_IMPACT)[enemy_add::e#0] = -$1e -- pbsc1_derefidx_vbum1=vbsc2 
    lda #-$1e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_IMPACT,y
    // stage_flightpath_t* flightpath = wave.enemy_flightpath[w]
    // [1023] enemy_add::$7 = enemy_add::w#0 << 1 -- vbum1=vbum2_rol_1 
    lda w
    asl
    sta enemy_add__7
    // [1024] enemy_add::flightpath#0 = ((stage_flightpath_t **)&wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_FLIGHTPATH)[enemy_add::$7] -- pssz1=qssc1_derefidx_vbum2 
    tay
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_FLIGHTPATH,y
    sta.z flightpath
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_ENEMY_FLIGHTPATH+1,y
    sta.z flightpath+1
    // flight.flightpath[e] = flightpath
    // [1025] enemy_add::$8 = enemy_add::e#0 << 1 -- vbuxx=vbum1_rol_1 
    lda e
    asl
    tax
    // [1026] ((stage_flightpath_t **)&flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH)[enemy_add::$8] = enemy_add::flightpath#0 -- qssc1_derefidx_vbuxx=pssz1 
    lda.z flightpath
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH,x
    lda.z flightpath+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FLIGHTPATH+1,x
    // flight.xf[e] = 0
    // [1027] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_XF)[enemy_add::e#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy e
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XF,y
    // flight.yf[e] = 0
    // [1028] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_YF)[enemy_add::e#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YF,y
    // flight.xi[e] = (unsigned int)wave.x[w]
    // [1029] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[enemy_add::$8] = (unsigned int)((int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_X)[enemy_add::$7] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbum1 
    ldy enemy_add__7
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_X,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_X+1,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[e] = (unsigned int)wave.y[w]
    // [1030] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[enemy_add::$8] = (unsigned int)((int *)&wave+OFFSET_STRUCT_STAGE_WAVE_T_Y)[enemy_add::$7] -- pwuc1_derefidx_vbuxx=pwuc2_derefidx_vbum1 
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_Y,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda wave+OFFSET_STRUCT_STAGE_WAVE_T_Y+1,y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // flight.xd[e] = 0
    // [1031] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[enemy_add::$8] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,x
    // flight.yd[e] = 0
    // [1032] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[enemy_add::$8] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,x
    // enemy_add::@return
    // }
    // [1033] return 
    rts
  .segment DataEngineEnemies
    enemy_add__7: .byte 0
  .segment Data
    w: .byte 0
  .segment DataEngineEnemies
    e: .byte 0
}
.segment Code
  // ht_insert
// char ht_insert(ht_item_t *ht, __mem() char key, __mem() char data)
ht_insert: {
    .label ht = collision_hash
    // [1035] phi from ht_insert to ht_insert::ht_hash1 [phi:ht_insert->ht_insert::ht_hash1]
    // ht_insert::ht_hash1
    // ht_insert::@3
    // [1036] ht_insert::ht_index#5 = ht_insert::key#0 -- vbuxx=vbum1 
    ldx key
    // [1037] phi from ht_insert::@3 ht_insert::ht_hash_next1 to ht_insert::@1 [phi:ht_insert::@3/ht_insert::ht_hash_next1->ht_insert::@1]
    // [1037] phi ht_insert::ht_index#2 = ht_insert::ht_index#5 [phi:ht_insert::@3/ht_insert::ht_hash_next1->ht_insert::@1#0] -- register_copy 
    // ht_insert::@1
  __b1:
    // ht_next = ht->next[ht_index]
    // [1038] ht_insert::ht_next#1 = ((char *)ht_insert::ht#0+OFFSET_STRUCT_HT_ITEM_T_NEXT)[ht_insert::ht_index#2] -- vbum1=pbuc1_derefidx_vbuxx 
    lda ht+OFFSET_STRUCT_HT_ITEM_T_NEXT,x
    sta ht_next
    // ht_key = ht->key[ht_index]
    // [1039] ht_insert::ht_key#1 = ((char *)ht_insert::ht#0)[ht_insert::ht_index#2] -- vbuyy=pbuc1_derefidx_vbuxx 
    ldy ht,x
    // while ((ht_next = ht->next[ht_index]) && (ht_key = ht->key[ht_index]) != key)
    // [1040] if(0==ht_insert::ht_next#1) goto ht_insert::@2 -- 0_eq_vbum1_then_la1 
    beq __b2
    // ht_insert::@4
    // [1041] if(ht_insert::ht_key#1!=ht_insert::key#0) goto ht_insert::ht_hash_next1 -- vbuyy_neq_vbum1_then_la1 
    cpy key
    bne ht_hash_next1
    // ht_insert::@2
  __b2:
    // ht->key[ht_index] = key
    // [1042] ((char *)ht_insert::ht#0)[ht_insert::ht_index#2] = ht_insert::key#0 -- pbuc1_derefidx_vbuxx=vbum1 
    lda key
    sta ht,x
    // ht_list.data[ht_list_pool] = data
    // [1043] ((char *)&ht_list)[ht_list_pool] = ht_insert::data#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda data
    ldy ht_list_pool
    sta ht_list,y
    // ht_list.next[ht_list_pool] = ht_next
    // [1044] ((char *)&ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT)[ht_list_pool] = ht_insert::ht_next#1 -- pbuc1_derefidx_vbum1=vbum2 
    // Now the new node becomes the first node in the list;
    lda ht_next
    sta ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT,y
    // ht->next[ht_index] = ht_list_pool
    // [1045] ((char *)ht_insert::ht#0+OFFSET_STRUCT_HT_ITEM_T_NEXT)[ht_insert::ht_index#2] = ht_list_pool -- pbuc1_derefidx_vbuxx=vbum1 
    tya
    sta ht+OFFSET_STRUCT_HT_ITEM_T_NEXT,x
    // ht_list_pool--;
    // [1046] ht_list_pool = -- ht_list_pool -- vbum1=_dec_vbum1 
    dec ht_list_pool
    // ht_insert::@return
    // }
    // [1047] return 
    rts
    // ht_insert::ht_hash_next1
  ht_hash_next1:
    // index+1
    // [1048] ht_insert::ht_hash_next1_return#0 = ht_insert::ht_index#2 + 1 -- vbuxx=vbuxx_plus_1 
    inx
    jmp __b1
  .segment Data
    .label ht_next = collision_data.y
    .label key = collision_detect.gy
    .label data = collision_detect.gx
}
.segment CodeEngineBullets
  // bullet_add
// char bullet_add(__mem() unsigned int sx, __mem() unsigned int sy, __mem() unsigned int tx, __mem() unsigned int ty, __mem() char speed, __register(X) char side, __register(Y) char sprite_bullet)
// __bank(cx16_ram, 7) 
bullet_add: {
    .label math_vecy1_return = $47
    // flight_index_t b = flight_add(FLIGHT_BULLET, side, sprite_bullet)
    // [1049] flight_add::type = 3 -- vbum1=vbuc1 
    lda #3
    sta equinoxe_flightengine.flight_add.type
    // [1050] flight_add::side = bullet_add::side#0 -- vbum1=vbuxx 
    stx equinoxe_flightengine.flight_add.side
    // [1051] flight_add::sprite = bullet_add::sprite_bullet#0 -- vbum1=vbuyy 
    sty equinoxe_flightengine.flight_add.sprite
    // [1052] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [1053] bullet_add::b#0 = flight_add::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_add.return
    sta b
    // sx >> 2
    // [1054] bullet_add::$1 = bullet_add::sx#0 >> 2 -- vwum1=vwum2_ror_2 
    lda sx+1
    lsr
    sta bullet_add__1+1
    lda sx
    ror
    sta bullet_add__1
    lsr bullet_add__1+1
    ror bullet_add__1
    // unsigned char asx = BYTE0(sx >> 2)
    // [1055] bullet_add::asx#0 = byte0  bullet_add::$1 -- vbum1=_byte0_vwum2 
    lda bullet_add__1
    sta asx
    // sy >> 2
    // [1056] bullet_add::$3 = bullet_add::sy#0 >> 2 -- vwum1=vwum2_ror_2 
    lda sy+1
    lsr
    sta bullet_add__3+1
    lda sy
    ror
    sta bullet_add__3
    lsr bullet_add__3+1
    ror bullet_add__3
    // unsigned char asy = BYTE0(sy >> 2)
    // [1057] bullet_add::asy#0 = byte0  bullet_add::$3 -- vbum1=_byte0_vwum2 
    lda bullet_add__3
    sta asy
    // tx >> 2
    // [1058] bullet_add::$5 = bullet_add::tx#0 >> 2 -- vwum1=vwum2_ror_2 
    lda tx+1
    lsr
    sta bullet_add__5+1
    lda tx
    ror
    sta bullet_add__5
    lsr bullet_add__5+1
    ror bullet_add__5
    // unsigned char atx = BYTE0(tx >> 2)
    // [1059] bullet_add::atx#0 = byte0  bullet_add::$5 -- vbuxx=_byte0_vwum1 
    ldx bullet_add__5
    // ty >> 2
    // [1060] bullet_add::$7 = bullet_add::ty#0 >> 2 -- vwum1=vwum2_ror_2 
    lda ty+1
    lsr
    sta bullet_add__7+1
    lda ty
    ror
    sta bullet_add__7
    lsr bullet_add__7+1
    ror bullet_add__7
    // unsigned char aty = BYTE0(ty >> 2)
    // [1061] bullet_add::aty#0 = byte0  bullet_add::$7 -- vbuyy=_byte0_vwum1 
    ldy bullet_add__7
    // unsigned char angle = math_atan2(asx, atx, asy, aty)
    // [1062] bullet_add::math_atan21_x1 = bullet_add::asx#0 -- vbum1=vbum2 
    lda asx
    sta math_atan21_x1
    // [1063] bullet_add::math_atan21_x2 = bullet_add::atx#0 -- vbum1=vbuxx 
    stx math_atan21_x2
    // [1064] bullet_add::math_atan21_y1 = bullet_add::asy#0 -- vbum1=vbum2 
    lda asy
    sta math_atan21_y1
    // [1065] bullet_add::math_atan21_y2 = bullet_add::aty#0 -- vbum1=vbuyy 
    sty math_atan21_y2
    // bullet_add::math_atan21
    // unsigned char octant_temp
    // [1066] bullet_add::math_atan21_octant_temp = 0 -- vbum1=vbuc1 
    lda #0
    sta math_atan21_octant_temp
    // unsigned char angle
    // [1067] bullet_add::math_atan21_angle = 0 -- vbum1=vbuc1 
    sta math_atan21_angle
    // asm
    // asm { lday2 sbcy1 bcs!+ eor#$ff !: tax roloctant_temp ldax1 sbcx2 bcs!+ eor#$ff !: tay roloctant_temp ldalogtab,x sbclogtab,y bcc!+ eor#$ff !: tax ldaoctant_temp rol and#%111 tay ldaatantab,x eoradjust_octant,y staangle  }
    tya
    sbc math_atan21_y1
    bcs !+
    eor #$ff
  !:
    tax
    rol math_atan21_octant_temp
    lda math_atan21_x1
    sbc math_atan21_x2
    bcs !+
    eor #$ff
  !:
    tay
    rol math_atan21_octant_temp
    lda logtab,x
    sbc logtab,y
    bcc !+
    eor #$ff
  !:
    tax
    lda math_atan21_octant_temp
    rol
    and #7
    tay
    lda atantab,x
    eor adjust_octant,y
    sta math_atan21_angle
    // return angle;
    // [1069] bullet_add::math_atan21_return#0 = bullet_add::math_atan21_angle -- vbuaa=vbum1 
    // bullet_add::math_atan21_@return
    // }
    // [1070] bullet_add::math_atan21_return#1 = bullet_add::math_atan21_return#0
    // bullet_add::@1
    // unsigned char angle = math_atan2(asx, atx, asy, aty)
    // [1071] bullet_add::angle#0 = bullet_add::math_atan21_return#1
    // signed int dx = math_vecx(angle-16, speed)
    // [1072] bullet_add::math_vecy1_angle#0 = bullet_add::angle#0 - $10 -- vbuxx=vbuaa_minus_vbuc1 
    sec
    sbc #$10
    tax
    // bullet_add::math_vecx1
    // if (speed)
    // [1073] if(0==bullet_add::speed#0) goto bullet_add::math_vecx1_@1 -- 0_eq_vbum1_then_la1 
    lda speed
    beq __b1
    // bullet_add::math_vecx1_@2
    // angle % 64
    // [1074] bullet_add::math_vecx1_$1 = bullet_add::math_vecy1_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dx = math_cos[angle % 64]
    // [1075] bullet_add::math_vecx1_$2 = bullet_add::math_vecx1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [1076] bullet_add::math_vecx1_dx#1 = math_cos[bullet_add::math_vecx1_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_cos,y
    sta math_vecx1_dx
    lda math_cos+1,y
    sta math_vecx1_dx+1
    // dx <<= speed
    // [1077] bullet_add::math_vecx1_dx#2 = bullet_add::math_vecx1_dx#1 << bullet_add::speed#0 -- vwsm1=vwsm2_rol_vbum3 
    ldy speed
    lda math_vecx1_dx
    sta math_vecx1_dx_1
    lda math_vecx1_dx+1
    sta math_vecx1_dx_1+1
    cpy #0
    beq !e+
  !:
    asl math_vecx1_dx_1
    rol math_vecx1_dx_1+1
    dey
    bne !-
  !e:
    // [1078] phi from bullet_add::math_vecx1_@2 to bullet_add::math_vecx1_@1 [phi:bullet_add::math_vecx1_@2->bullet_add::math_vecx1_@1]
    // [1078] phi bullet_add::dx#1 = bullet_add::math_vecx1_dx#2 [phi:bullet_add::math_vecx1_@2->bullet_add::math_vecx1_@1#0] -- register_copy 
    jmp math_vecy1
    // [1078] phi from bullet_add::math_vecx1 to bullet_add::math_vecx1_@1 [phi:bullet_add::math_vecx1->bullet_add::math_vecx1_@1]
  __b1:
    // [1078] phi bullet_add::dx#1 = 0 [phi:bullet_add::math_vecx1->bullet_add::math_vecx1_@1#0] -- vwsm1=vwsc1 
    lda #<0
    sta dx
    sta dx+1
    // bullet_add::math_vecx1_@1
    // bullet_add::math_vecy1
  math_vecy1:
    // if (speed)
    // [1079] if(0==bullet_add::speed#0) goto bullet_add::math_vecy1_@1 -- 0_eq_vbum1_then_la1 
    lda speed
    beq __b3
    // bullet_add::math_vecy1_@2
    // angle % 64
    // [1080] bullet_add::math_vecy1_$1 = bullet_add::math_vecy1_angle#0 & $40-1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$40-1
    // dy = math_sin[angle % 64]
    // [1081] bullet_add::math_vecy1_$2 = bullet_add::math_vecy1_$1 << 1 -- vbuaa=vbuaa_rol_1 
    asl
    // [1082] bullet_add::math_vecy1_dy#1 = math_sin[bullet_add::math_vecy1_$2] -- vwsm1=pwsc1_derefidx_vbuaa 
    tay
    lda math_sin,y
    sta math_vecy1_dy
    lda math_sin+1,y
    sta math_vecy1_dy+1
    // dy <<= speed
    // [1083] bullet_add::math_vecy1_dy#2 = bullet_add::math_vecy1_dy#1 << bullet_add::speed#0 -- vwsm1=vwsm1_rol_vbum2 
    ldy speed
    beq !e+
  !:
    asl math_vecy1_dy
    rol math_vecy1_dy+1
    dey
    bne !-
  !e:
    // [1084] phi from bullet_add::math_vecy1_@2 to bullet_add::math_vecy1_@1 [phi:bullet_add::math_vecy1_@2->bullet_add::math_vecy1_@1]
    // [1084] phi bullet_add::math_vecy1_return#0 = bullet_add::math_vecy1_dy#2 [phi:bullet_add::math_vecy1_@2->bullet_add::math_vecy1_@1#0] -- vwsz1=vwsm2 
    lda math_vecy1_dy
    sta.z math_vecy1_return
    lda math_vecy1_dy+1
    sta.z math_vecy1_return+1
    jmp __b2
    // [1084] phi from bullet_add::math_vecy1 to bullet_add::math_vecy1_@1 [phi:bullet_add::math_vecy1->bullet_add::math_vecy1_@1]
  __b3:
    // [1084] phi bullet_add::math_vecy1_return#0 = 0 [phi:bullet_add::math_vecy1->bullet_add::math_vecy1_@1#0] -- vwsz1=vwsc1 
    lda #<0
    sta.z math_vecy1_return
    sta.z math_vecy1_return+1
    // bullet_add::math_vecy1_@1
    // bullet_add::@2
  __b2:
    // flight.xd[b] = (unsigned int)dx
    // [1085] bullet_add::$20 = bullet_add::b#0 << 1 -- vbuxx=vbum1_rol_1 
    lda b
    asl
    tax
    // [1086] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[bullet_add::$20] = (unsigned int)bullet_add::dx#1 -- pwuc1_derefidx_vbuxx=vwum1 
    lda dx
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,x
    lda dx+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,x
    // flight.yd[b] = (unsigned int)dy
    // [1087] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[bullet_add::$20] = (unsigned int)bullet_add::math_vecy1_return#0 -- pwuc1_derefidx_vbuxx=vwuz1 
    lda.z math_vecy1_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,x
    lda.z math_vecy1_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,x
    // flight.xi[b] = sx
    // [1088] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[bullet_add::$20] = bullet_add::sx#0 -- pwuc1_derefidx_vbuxx=vwum1 
    lda sx
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda sx+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[b] = sy
    // [1089] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[bullet_add::$20] = bullet_add::sy#0 -- pwuc1_derefidx_vbuxx=vwum1 
    lda sy
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda sy+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // flight.speed[b] = speed
    // [1090] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[bullet_add::b#0] = bullet_add::speed#0 -- pbuc1_derefidx_vbum1=vbum2 
    lda speed
    ldy b
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SPEED,y
    // animate_add(
    //         sprite_cache.count[flight.cache[b]], 
    //         0, 
    //         sprite_cache.loop[flight.cache[b]], 
    //         1, 
    //         1, 
    //         sprite_cache.reverse[flight.cache[b]]
    //         )
    // [1091] animate_add::count = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT)[((char *)&flight)[bullet_add::b#0]] -- vbum1=pbuc1_derefidx_(pbuc2_derefidx_vbum2) 
    ldx b
    ldy equinoxe_flightengine.flight,x
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT,y
    stx equinoxe_animate.animate_add.count
    // [1092] animate_add::state = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_animate.animate_add.state
    // [1093] animate_add::loop = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP)[((char *)&flight)[bullet_add::b#0]] -- vbum1=pbuc1_derefidx_(pbuc2_derefidx_vbum2) 
    ldx b
    ldy equinoxe_flightengine.flight,x
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP,y
    stx equinoxe_animate.animate_add.loop
    // [1094] animate_add::speed = 1 -- vbum1=vbuc1 
    lda #1
    sta equinoxe_animate.animate_add.speed
    // [1095] animate_add::direction = 1 -- vbsm1=vbsc1 
    sta equinoxe_animate.animate_add.direction
    // [1096] animate_add::reverse = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE)[((char *)&flight)[bullet_add::b#0]] -- vbum1=pbuc1_derefidx_(pbuc2_derefidx_vbum2) 
    ldx b
    ldy equinoxe_flightengine.flight,x
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE,y
    stx equinoxe_animate.animate_add.reverse
    // [1097] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [1098] bullet_add::$14 = animate_add::return -- vbuaa=vbum1 
    lda equinoxe_animate.animate_add.return
    // flight.animate[b] = animate_add(
    //         sprite_cache.count[flight.cache[b]], 
    //         0, 
    //         sprite_cache.loop[flight.cache[b]], 
    //         1, 
    //         1, 
    //         sprite_cache.reverse[flight.cache[b]]
    //         )
    // [1099] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[bullet_add::b#0] = bullet_add::$14 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy b
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // rand()
    // [1100] call rand
    jsr rand
    // [1101] rand::return#2 = rand::return#0
    // bullet_add::@3
    // [1102] bullet_add::$15 = rand::return#2 -- vwum1=vwum2 
    lda rand.return
    sta bullet_add__15
    lda rand.return+1
    sta bullet_add__15+1
    // BYTE0(rand())
    // [1103] bullet_add::$16 = byte0  bullet_add::$15 -- vbuaa=_byte0_vwum1 
    lda bullet_add__15
    // BYTE0(rand())>>4
    // [1104] bullet_add::impact#0 = bullet_add::$16 >> 4 -- vbuxx=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    tax
    // flight.health[b] = 0
    // [1105] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[bullet_add::b#0] = 0 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #0
    ldy b
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    // -impact
    // [1106] bullet_add::$18 = - (signed char)bullet_add::impact#0 -- vbsaa=_neg_vbsxx 
    txa
    eor #$ff
    clc
    adc #1
    // flight.impact[b] = -impact
    // [1107] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_IMPACT)[bullet_add::b#0] = bullet_add::$18 -- pbsc1_derefidx_vbum1=vbsaa 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_IMPACT,y
    // bullet_add::@return
    // }
    // [1108] return 
    rts
  .segment DataEngineBullets
    .label bullet_add__1 = dx
    .label bullet_add__3 = dx
    .label bullet_add__5 = dx
    .label bullet_add__7 = dx
    .label bullet_add__15 = dx
  .segment Data
    math_atan21_x1: .byte 0
    math_atan21_x2: .byte 0
    math_atan21_y1: .byte 0
    math_atan21_y2: .byte 0
    math_atan21_octant_temp: .byte 0
    math_atan21_angle: .byte 0
    .label sx = enemy_logic.math_vecx1_dx
    .label sy = stage_bullet_add.sy
    .label tx = stage_bullet_add.tx
    .label ty = stage_bullet_add.ty
    .label speed = collision_detect.gx
  .segment DataEngineBullets
    .label b = bullet_logic.b
    .label asx = bullet_logic.b_1
    asy: .byte 0
  .segment Data
    .label math_vecx1_dx = stage_bullet_add.tx
    .label math_vecx1_dx_1 = dx
    .label math_vecy1_dy = stage_bullet_add.tx
  .segment DataEngineBullets
    dx: .word 0
}
.segment CodeEngineEnemies
  // enemy_get_wave
// __register(A) char enemy_get_wave(__register(X) char e)
// __bank(cx16_ram, 8) 
enemy_get_wave: {
    // return flight.wave[e];
    // [1109] enemy_get_wave::return#1 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_WAVE)[enemy_get_wave::e#0] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_WAVE,x
    // enemy_get_wave::@return
    // }
    // [1110] return 
    rts
}
  // enemy_remove
// void enemy_remove(__mem() char e)
// __bank(cx16_ram, 8) 
enemy_remove: {
    // if(flight.used[e])
    // [1111] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[enemy_remove::e#0]) goto enemy_remove::@return -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy e
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    beq __breturn
    // enemy_remove::@1
    // animate_del(flight.animate[e])
    // [1112] animate_del::a = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[enemy_remove::e#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta equinoxe_animate.animate_del.a
    // [1113] callexecute animate_del  -- call_var_near 
    jsr equinoxe_animate.animate_del
    // flight_remove(FLIGHT_ENEMY, e)
    // [1114] flight_remove::type = 1 -- vbum1=vbuc1 
    lda #1
    sta equinoxe_flightengine.flight_remove.type
    // [1115] flight_remove::f = enemy_remove::e#0 -- vbum1=vbum2 
    lda e
    sta equinoxe_flightengine.flight_remove.f
    // [1116] callexecute flight_remove  -- call_var_near 
    jsr equinoxe_flightengine.flight_remove
    // enemy_remove::@return
  __breturn:
    // }
    // [1117] return 
    rts
  .segment Data
    .label e = collision_insert.xmax
}
.segment Code
  // sgn_u8
// Get the sign of a 8-bit unsigned number treated as a signed number.
// Returns unsigned -1 if the number is <0.
// __register(A) char sgn_u8(__register(A) char b)
sgn_u8: {
    // b & 0x80
    // [1118] sgn_u8::$0 = sgn_u8::b#0 & $80 -- vbuaa=vbuaa_band_vbuc1 
    and #$80
    // if (b & 0x80)
    // [1119] if(0!=sgn_u8::$0) goto sgn_u8::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // [1121] phi from sgn_u8 to sgn_u8::@return [phi:sgn_u8->sgn_u8::@return]
    // [1121] phi sgn_u8::return#2 = 1 [phi:sgn_u8->sgn_u8::@return#0] -- vbuaa=vbuc1 
    lda #1
    rts
    // [1120] phi from sgn_u8 to sgn_u8::@1 [phi:sgn_u8->sgn_u8::@1]
    // sgn_u8::@1
  __b1:
    // [1121] phi from sgn_u8::@1 to sgn_u8::@return [phi:sgn_u8::@1->sgn_u8::@return]
    // [1121] phi sgn_u8::return#2 = -1 [phi:sgn_u8::@1->sgn_u8::@return#0] -- vbuaa=vbuc1 
    lda #-1
    // sgn_u8::@return
    // }
    // [1122] return 
    rts
}
  // abs_u8
// Get the absolute value of an 8-bit unsigned number treated as a signed number.
// __register(A) char abs_u8(__register(X) char b)
abs_u8: {
    // b & 0x80
    // [1123] abs_u8::$0 = abs_u8::b#0 & $80 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #$80
    // if (b & 0x80)
    // [1124] if(0!=abs_u8::$0) goto abs_u8::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // [1126] phi from abs_u8 to abs_u8::@return [phi:abs_u8->abs_u8::@return]
    // [1126] phi abs_u8::return#2 = abs_u8::b#0 [phi:abs_u8->abs_u8::@return#0] -- vbuaa=vbuxx 
    txa
    rts
    // abs_u8::@1
  __b1:
    // return -b;
    // [1125] abs_u8::return#0 = - abs_u8::b#0 -- vbuaa=_neg_vbuxx 
    dex
    txa
    eor #$ff
    // [1126] phi from abs_u8::@1 to abs_u8::@return [phi:abs_u8::@1->abs_u8::@return]
    // [1126] phi abs_u8::return#2 = abs_u8::return#0 [phi:abs_u8::@1->abs_u8::@return#0] -- register_copy 
    // abs_u8::@return
    // }
    // [1127] return 
    rts
}
  // mul8u
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// __mem() unsigned int mul8u(__register(X) char a, __register(A) char b)
mul8u: {
    // unsigned int mb = b
    // [1128] mul8u::mb#0 = (unsigned int)mul8u::b#0 -- vwum1=_word_vbuaa 
    sta mb
    lda #0
    sta mb+1
    // [1129] phi from mul8u to mul8u::@1 [phi:mul8u->mul8u::@1]
    // [1129] phi mul8u::mb#2 = mul8u::mb#0 [phi:mul8u->mul8u::@1#0] -- register_copy 
    // [1129] phi mul8u::res#2 = 0 [phi:mul8u->mul8u::@1#1] -- vwum1=vwuc1 
    sta res
    sta res+1
    // [1129] phi mul8u::a#2 = mul8u::a#1 [phi:mul8u->mul8u::@1#2] -- register_copy 
    // mul8u::@1
  __b1:
    // while(a!=0)
    // [1130] if(mul8u::a#2!=0) goto mul8u::@2 -- vbuxx_neq_0_then_la1 
    cpx #0
    bne __b2
    // mul8u::@return
    // }
    // [1131] return 
    rts
    // mul8u::@2
  __b2:
    // a&1
    // [1132] mul8u::$1 = mul8u::a#2 & 1 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #1
    // if( (a&1) != 0)
    // [1133] if(mul8u::$1==0) goto mul8u::@3 -- vbuaa_eq_0_then_la1 
    cmp #0
    beq __b3
    // mul8u::@4
    // res = res + mb
    // [1134] mul8u::res#1 = mul8u::res#2 + mul8u::mb#2 -- vwum1=vwum1_plus_vwum2 
    clc
    lda res
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
    // [1135] phi from mul8u::@2 mul8u::@4 to mul8u::@3 [phi:mul8u::@2/mul8u::@4->mul8u::@3]
    // [1135] phi mul8u::res#6 = mul8u::res#2 [phi:mul8u::@2/mul8u::@4->mul8u::@3#0] -- register_copy 
    // mul8u::@3
  __b3:
    // a = a>>1
    // [1136] mul8u::a#0 = mul8u::a#2 >> 1 -- vbuxx=vbuxx_ror_1 
    txa
    lsr
    tax
    // mb = mb<<1
    // [1137] mul8u::mb#1 = mul8u::mb#2 << 1 -- vwum1=vwum1_rol_1 
    asl mb
    rol mb+1
    // [1129] phi from mul8u::@3 to mul8u::@1 [phi:mul8u::@3->mul8u::@1]
    // [1129] phi mul8u::mb#2 = mul8u::mb#1 [phi:mul8u::@3->mul8u::@1#0] -- register_copy 
    // [1129] phi mul8u::res#2 = mul8u::res#6 [phi:mul8u::@3->mul8u::@1#1] -- register_copy 
    // [1129] phi mul8u::a#2 = mul8u::a#0 [phi:mul8u::@3->mul8u::@1#2] -- register_copy 
    jmp __b1
  .segment Data
    .label mb = stage_bullet_add.sy
    .label res = enemy_logic.math_vecx1_dx
    .label return = enemy_logic.math_vecx1_dx
}
.segment CodeEngineStages
  // stage_player_remove
// void stage_player_remove(__register(A) char p)
// __bank(cx16_ram, 3) 
stage_player_remove: {
    // player_remove(p)
    // [1138] player_remove::p#0 = stage_player_remove::p#0 -- vbum1=vbuaa 
    sta player_remove.p
    // [1139] call player_remove -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <player_remove
    .byte >player_remove
    .byte 9
    // stage_player_remove::@1
    // stage.player_count--;
    // [1140] *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_COUNT) = -- *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_COUNT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec stage+OFFSET_STRUCT_STAGE_T_PLAYER_COUNT
    // stage_player_remove::@return
    // }
    // [1141] return 
    rts
}
  // stage_bullet_remove
// void stage_bullet_remove(__register(A) char b)
// __bank(cx16_ram, 3) 
stage_bullet_remove: {
    // bullet_remove(b)
    // [1142] bullet_remove::b#0 = stage_bullet_remove::b#0 -- vbum1=vbuaa 
    sta bullet_remove.b
    // [1143] call bullet_remove
    // [810] phi from stage_bullet_remove to bullet_remove [phi:stage_bullet_remove->bullet_remove]
    // [810] phi bullet_remove::b#2 = bullet_remove::b#0 [phi:stage_bullet_remove->bullet_remove#0] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <bullet_remove
    .byte >bullet_remove
    .byte 7
    // stage_bullet_remove::@1
    // stage.bullet_count--;
    // [1144] *((char *)&stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT) = -- *((char *)&stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT
    // stage_bullet_remove::@return
    // }
    // [1145] return 
    rts
}
  // stage_load_player
// void stage_load_player(__zp($43) stage_player_t *stage_player)
// __bank(cx16_ram, 3) 
stage_load_player: {
    .label stage_engine = $3d
    .label stage_bullet = $3d
    .label stage_player = $43
    // sprite_index_t player_sprite = stage_player->player_sprite
    // [1146] stage_load_player::player_sprite#0 = *((char *)stage_load_player::stage_player#0) -- vbuaa=_deref_pbuz1 
    // Loading the player sprites in bram.
    ldy #0
    lda (stage_player),y
    // fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [1147] fe_sprite_bram_load::sprite_index = stage_load_player::player_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [1148] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [1149] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [1150] stage_load_player::$0 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_player__0
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_player__0+1
    // stage.sprite_offset = fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [1151] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_player::$0 -- _deref_pwuc1=vwum1 
    lda stage_load_player__0
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_player__0+1
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_engine_t* stage_engine = stage_player->stage_engine
    // [1152] stage_load_player::stage_engine#0 = ((stage_engine_t **)stage_load_player::stage_player#0)[OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE] -- pssz1=qssz2_derefidx_vbuc1 
    // gotoxy(0,0);
    // printf("player_sprite = %u", player_sprite);
    ldy #OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE
    lda (stage_player),y
    sta.z stage_engine
    iny
    lda (stage_player),y
    sta.z stage_engine+1
    // sprite_index_t engine_sprite = stage_engine->engine_sprite
    // [1153] stage_load_player::engine_sprite#0 = *((char *)stage_load_player::stage_engine#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_engine),y
    // fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [1154] fe_sprite_bram_load::sprite_index = stage_load_player::engine_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [1155] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [1156] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [1157] stage_load_player::$1 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_player__1
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_player__1+1
    // stage.sprite_offset = fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [1158] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_player::$1 -- _deref_pwuc1=vwum1 
    lda stage_load_player__1
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_player__1+1
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_bullet_t* stage_bullet = stage_player->stage_bullet
    // [1159] stage_load_player::stage_bullet#0 = ((stage_bullet_t **)stage_load_player::stage_player#0)[OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET
    lda (stage_player),y
    sta.z stage_bullet
    iny
    lda (stage_player),y
    sta.z stage_bullet+1
    // sprite_index_t bullet_sprite = stage_bullet->bullet_sprite
    // [1160] stage_load_player::bullet_sprite#0 = *((char *)stage_load_player::stage_bullet#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_bullet),y
    // fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1161] fe_sprite_bram_load::sprite_index = stage_load_player::bullet_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [1162] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [1163] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [1164] stage_load_player::$2 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_player__2
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_player__2+1
    // stage.sprite_offset = fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1165] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_player::$2 -- _deref_pwuc1=vwum1 
    lda stage_load_player__2
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_player__2+1
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_load_player::@return
    // }
    // [1166] return 
    rts
  .segment DataEngineStages
    .label stage_load_player__0 = stage_load.scenario
    .label stage_load_player__1 = stage_load.scenario
    .label stage_load_player__2 = stage_load.scenario
}
.segment CodeEngineStages
  // stage_load_enemy
// void stage_load_enemy(__zp($4b) stage_enemy_t *stage_enemy)
// __bank(cx16_ram, 3) 
stage_load_enemy: {
    .label stage_bullet = $3d
    .label stage_enemy = $4b
    // sprite_index_t enemy_sprite = stage_enemy->enemy_sprite_flight
    // [1167] stage_load_enemy::enemy_sprite#0 = *((char *)stage_load_enemy::stage_enemy#0) -- vbuaa=_deref_pbuz1 
    // Loading the enemy sprites in bram.
    ldy #0
    lda (stage_enemy),y
    // fe_sprite_bram_load(enemy_sprite, stage.sprite_offset)
    // [1168] fe_sprite_bram_load::sprite_index = stage_load_enemy::enemy_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [1169] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [1170] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [1171] stage_load_enemy::$0 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_enemy__0
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_enemy__0+1
    // stage.sprite_offset = fe_sprite_bram_load(enemy_sprite, stage.sprite_offset)
    // [1172] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_enemy::$0 -- _deref_pwuc1=vwum1 
    lda stage_load_enemy__0
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_enemy__0+1
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_bullet_t* stage_bullet = stage_enemy->stage_bullet
    // [1173] stage_load_enemy::stage_bullet#0 = ((stage_bullet_t **)stage_load_enemy::stage_enemy#0)[OFFSET_STRUCT_STAGE_ENEMY_T_STAGE_BULLET] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ENEMY_T_STAGE_BULLET
    lda (stage_enemy),y
    sta.z stage_bullet
    iny
    lda (stage_enemy),y
    sta.z stage_bullet+1
    // sprite_index_t bullet_sprite = stage_bullet->bullet_sprite
    // [1174] stage_load_enemy::bullet_sprite#0 = *((char *)stage_load_enemy::stage_bullet#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_bullet),y
    // fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1175] fe_sprite_bram_load::sprite_index = stage_load_enemy::bullet_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [1176] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [1177] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [1178] stage_load_enemy::$1 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_enemy__1
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_enemy__1+1
    // stage.sprite_offset = fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [1179] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_enemy::$1 -- _deref_pwuc1=vwum1 
    lda stage_load_enemy__1
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_enemy__1+1
    sta stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_load_enemy::@return
    // }
    // [1180] return 
    rts
  .segment DataEngineStages
    .label stage_load_enemy__0 = stage_load.stage_load__6
    .label stage_load_enemy__1 = stage_load.stage_load__6
}
.segment CodeEnginePlayers
  // player_remove
// void player_remove(__mem() char p)
// __bank(cx16_ram, 9) 
player_remove: {
    // if (flight.used[p])
    // [1181] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[player_remove::p#0]) goto player_remove::@return -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    beq __breturn
    // player_remove::@1
    // unsigned char n = flight.engine[p]
    // [1182] player_remove::n#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENGINE)[player_remove::p#0] -- vbum1=pbuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENGINE,y
    sta n
    // animate_del(flight.animate[n])
    // [1183] animate_del::a = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_remove::n#0] -- vbum1=pbuc1_derefidx_vbum2 
    tay
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta equinoxe_animate.animate_del.a
    // [1184] callexecute animate_del  -- call_var_near 
    jsr equinoxe_animate.animate_del
    // flight_remove(FLIGHT_ENGINE, n)
    // [1185] flight_remove::type = 4 -- vbum1=vbuc1 
    // Remove the animation of the engine sprite.
    lda #4
    sta equinoxe_flightengine.flight_remove.type
    // [1186] flight_remove::f = player_remove::n#0 -- vbum1=vbum2 
    lda n
    sta equinoxe_flightengine.flight_remove.f
    // [1187] callexecute flight_remove  -- call_var_near 
    jsr equinoxe_flightengine.flight_remove
    // animate_del(flight.animate[p])
    // [1188] animate_del::a = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_remove::p#0] -- vbum1=pbuc1_derefidx_vbum2 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta equinoxe_animate.animate_del.a
    // [1189] callexecute animate_del  -- call_var_near 
    jsr equinoxe_animate.animate_del
    // flight_remove(FLIGHT_PLAYER, p)
    // [1190] flight_remove::type = 0 -- vbum1=vbuc1 
    // Remove the animation of the player sprite.
    lda #0
    sta equinoxe_flightengine.flight_remove.type
    // [1191] flight_remove::f = player_remove::p#0 -- vbum1=vbum2 
    lda p
    sta equinoxe_flightengine.flight_remove.f
    // [1192] callexecute flight_remove  -- call_var_near 
    jsr equinoxe_flightengine.flight_remove
    // stage.player_respawn = 8
    // [1193] *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN) = 8 -- _deref_pbuc1=vbuc2 
    lda #8
    sta stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN
    // player_remove::@return
  __breturn:
    // }
    // [1194] return 
    rts
  .segment DataEnginePlayers
    .label n = player_logic.p
  .segment Data
    .label p = collision_data.y
}
  // File Data Internal or Ignore
  // #pragma data_seg(Math)
math_sin:
.fillword 64, 128*sin(toRadians(i*360/64))

math_cos:
.fillword 64, 128*cos(toRadians(i*360/64))

  .align $100
logtab:
.fill $100, (log(i)/log(2))*32

  .align $100
atantab:
.for(var i=-256;i<0;i++) {
    .byte (atan(pow(2.0,(i/32.0)))*64/(PI*2))
	}
//    .fill $100, i

  .align $100
adjust_octant:
.byte %00001111		// x+,y+,|x|>|y|
	.byte %00000000		// x+,y+,|x|<|y|
	.byte %00110000		// x+,y-,|x|>|y|
	.byte %00111111		// x+,y-,|x|<|y|
	.byte %00010000		// x-,y+,|x|>|y|
	.byte %00011111		// x-,y+,|x|<|y|
	.byte %00101111		// x-,y-,|x|>|y|
	.byte %00100000		// x-,y-,|x|<|y|

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
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  .fill SIZEOF_STRUCT_STAGE_SCENARIO_T, 0
  stage_floor_bram_tiles_01: .word mars_land_bram, mars_sand_bram, mars_sea_bram, metal_yellow_bram, metal_red_bram, metal_grey_bram
  stage_tower_bram_tiles_01: .word tower_bram, mars_sea_bram
  // This models the playbook of all the different levels in the game.
  // The embedded level field in the playbook is a pointer to a level composition.
  stage_playbooks_b: .byte $13
  .word stage_scenario_01_b, stage_player, stage_floor_01
  .byte 1
  .word stage_towers_01
.segment BramEngineFlight
  __50: .text "t001"
  .byte 0
  __51: .text "p001"
  .byte 0
  __52: .text "n001"
  .byte 0
  __53: .text "e0701"
  .byte 0
  __54: .text "e0102"
  .byte 0
  __55: .text "e0201"
  .byte 0
  __56: .text "e0202"
  .byte 0
  __57: .text "e0301"
  .byte 0
  __58: .text "e0302"
  .byte 0
  __59: .text "e0401"
  .byte 0
  __60: .text "e0501"
  .byte 0
  __61: .text "e0502"
  .byte 0
  __62: .text "e0601"
  .byte 0
  __63: .text "e0602"
  .byte 0
  __64: .text "e0101"
  .byte 0
  __65: .text "e0702"
  .byte 0
  __66: .text "e0703"
  .byte 0
  __67: .text "b001"
  .byte 0
  __68: .text "b002"
  .byte 0
  __69: .text "b003"
  .byte 0
  __70: .text "b004"
  .byte 0
.segment Data
  // The random state variable
  rand_state: .word 1
  nmi_relay: .word 0
  brk_relay: .word 0
  isr_vsync: .word 0
  // The mouse work area.
  cx16_mouse: .fill SIZEOF_STRUCT_CX16_MOUSE_T, 0
  ht_list: .fill SIZEOF_STRUCT_HT_LIST_S, 0
  ht_list_pool: .byte 0
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
  sprites: .word __50, __51, __52, __53, __54, __55, __56, __57, __58, __59, __60, __61, __62, __63, __64, __65, __66, __67, __68, __69, __70
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
  collision_hash: .fill SIZEOF_STRUCT_HT_ITEM_T, 0
  collision_quadrant: .fill SIZEOF_STRUCT_COLLISION_QUADRANT_T, 0
.segment DataEngineStages
  wave: .fill SIZEOF_STRUCT_STAGE_WAVE_T, 0
  stage: .fill SIZEOF_STRUCT_STAGE_T, 0
.segment Data
  game: .byte 1, 0, 0
  .word 0
  .byte 0, $7f, $40, 1, 2, $a, $f, $f, 1, -1
 // Asm import library lib_conio:
#define __asm_import__lib_conio__
#import "lib_conio.asm"

 // Asm import library equinoxe-flightengine:
#define __asm_import__equinoxe_flightengine__
#import "equinoxe-flightengine.asm"

 // Asm import library lib_file:
#define __asm_import__lib_file__
#import "lib_file.asm"

 // Asm import library lib_lru_cache:
#define __asm_import__lib_lru_cache__
#import "lib_lru_cache.asm"

 // Asm import library lib_bramheap:
#define __asm_import__lib_bramheap__
#import "lib_bramheap.asm"

 // Asm import library lib_veraheap:
#define __asm_import__lib_veraheap__
#import "lib_veraheap.asm"

 // Asm import library equinoxe-palette:
#define __asm_import__equinoxe_palette__
#import "equinoxe-palette.asm"

 // Asm import library equinoxe-animate:
#define __asm_import__equinoxe_animate__
#import "equinoxe-animate.asm"

 // Asm import library cx16_file:
#define __asm_import__cx16_file__
#import "cx16_file.asm"

 // Asm import library equinoxe-layers:
#define __asm_import__equinoxe_layers__
#import "equinoxe-layers.asm"

