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
  .label OFFSET_STRUCT_CX16_MOUSE_T_WAIT = 9
  .label OFFSET_STRUCT_CX16_MOUSE_T_Y = 2
  .label OFFSET_STRUCT_CX16_MOUSE_T_STATUS = 8
  .label OFFSET_STRUCT_CX16_MOUSE_T_PX = 4
  .label OFFSET_STRUCT_CX16_MOUSE_T_PY = 6
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
  .label OFFSET_STRUCT_FLIGHT_T_TYPE = $180
  .label OFFSET_STRUCT_FLIGHT_T_SPEED = $7c0
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT = $20
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP = $f0
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE = $d0
  .label OFFSET_STRUCT_STAGE_T_SCRIPT_B = $15
  .label OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B = 1
  .label OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT = $1a
  .label OFFSET_STRUCT_STAGE_T_LIVES = $34
  .label OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL = $1e
  .label OFFSET_STRUCT_STAGE_T_EW = $18
  .label OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT = $1c
  .label OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER = 3
  .label OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE = 1
  .label OFFSET_STRUCT_STAGE_T_ENEMY_COUNT = $13
  .label OFFSET_STRUCT_WAVE_T_USED = $78
  .label OFFSET_STRUCT_WAVE_T_WAIT = $68
  .label OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN = 8
  .label OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE = $28
  .label OFFSET_STRUCT_WAVE_T_FINISHED = $80
  .label OFFSET_STRUCT_WAVE_T_ENEMY_SPRITE = $10
  .label OFFSET_STRUCT_WAVE_T_SCENARIO = $88
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_PREV = $e
  .label OFFSET_STRUCT_STAGE_T_BULLET_COUNT = $11
  .label OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B = 1
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_X = 6
  .label OFFSET_STRUCT_WAVE_T_X = $30
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_Y = 8
  .label OFFSET_STRUCT_WAVE_T_Y = $40
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_DX = $a
  .label OFFSET_STRUCT_WAVE_T_DX = $50
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_DY = $b
  .label OFFSET_STRUCT_WAVE_T_DY = $58
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_FLIGHTPATH = 4
  .label OFFSET_STRUCT_WAVE_T_ENEMY_FLIGHTPATH = $18
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_SPAWN = 1
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY = 2
  .label OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_SPEED = 4
  .label OFFSET_STRUCT_WAVE_T_ANIMATION_SPEED = $98
  .label OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_REVERSE = 5
  .label OFFSET_STRUCT_WAVE_T_ANIMATION_REVERSE = $a0
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_INTERVAL = $c
  .label OFFSET_STRUCT_WAVE_T_INTERVAL = $60
  .label OFFSET_STRUCT_WAVE_T_PREV = $70
  .label OFFSET_STRUCT_STAGE_SCENARIO_T_WAIT = $d
  .label OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET = $25
  .label OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET = 3
  .label OFFSET_STRUCT_STAGE_ENEMY_T_STAGE_BULLET = 2
  .label OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC = 1
  .label OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE = 2
  .label SIZEOF_STRUCT_STAGE_SCENARIO_T = $10
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
    // [137] phi from __start::@1 to __lib_conio_start [phi:__start::@1->__lib_conio_start]
    jsr lib_conio.__lib_conio_start
    // [6] phi from __start::@1 to __start::@2 [phi:__start::@1->__start::@2]
    // __start::@2
    // [7] call __lib_lru_cache_start
    // [139] phi from __start::@2 to __lib_lru_cache_start [phi:__start::@2->__lib_lru_cache_start]
    jsr lib_lru_cache.__lib_lru_cache_start
    // [8] phi from __start::@2 to __start::@3 [phi:__start::@2->__start::@3]
    // __start::@3
    // [9] call __lib_veraheap_start
    // [141] phi from __start::@3 to __lib_veraheap_start [phi:__start::@3->__lib_veraheap_start]
    jsr lib_veraheap.__lib_veraheap_start
    // [10] phi from __start::@3 to __start::@4 [phi:__start::@3->__start::@4]
    // __start::@4
    // [11] call __lib_bramheap_start
    // [143] phi from __start::@4 to __lib_bramheap_start [phi:__start::@4->__lib_bramheap_start]
    jsr lib_bramheap.__lib_bramheap_start
    // [12] phi from __start::@4 to __start::@5 [phi:__start::@4->__start::@5]
    // __start::@5
    // [13] call __lib_file_start
    // [145] phi from __start::@5 to __lib_file_start [phi:__start::@5->__lib_file_start]
    jsr lib_file.__lib_file_start
    // [14] phi from __start::@5 to __start::@6 [phi:__start::@5->__start::@6]
    // __start::@6
    // [15] call __equinoxe_layers_start
    // [147] phi from __start::@6 to __equinoxe_layers_start [phi:__start::@6->__equinoxe_layers_start]
    jsr equinoxe_layers.__equinoxe_layers_start
    // [16] phi from __start::@6 to __start::@7 [phi:__start::@6->__start::@7]
    // __start::@7
    // [17] call __equinoxe_animate_start
    // [149] phi from __start::@7 to __equinoxe_animate_start [phi:__start::@7->__equinoxe_animate_start]
    jsr equinoxe_animate.__equinoxe_animate_start
    // [18] phi from __start::@7 to __start::@8 [phi:__start::@7->__start::@8]
    // __start::@8
    // [19] call __equinoxe_palette_start
    // [151] phi from __start::@8 to __equinoxe_palette_start [phi:__start::@8->__equinoxe_palette_start]
    jsr equinoxe_palette.__equinoxe_palette_start
    // [20] phi from __start::@8 to __start::@9 [phi:__start::@8->__start::@9]
    // __start::@9
    // [21] call __equinoxe_flightengine_start
    // [153] phi from __start::@9 to __equinoxe_flightengine_start [phi:__start::@9->__equinoxe_flightengine_start]
    jsr equinoxe_flightengine.__equinoxe_flightengine_start
    // [22] phi from __start::@9 to __start::@10 [phi:__start::@9->__start::@10]
    // __start::@10
    // [23] call __equinoxe_waves_start
    // [155] phi from __start::@10 to __equinoxe_waves_start [phi:__start::@10->__equinoxe_waves_start]
    jsr equinoxe_waves.__equinoxe_waves_start
    // [24] phi from __start::@10 to __start::@11 [phi:__start::@10->__start::@11]
    // __start::@11
    // [25] call __equinoxe_stage_flight_start
    // [157] phi from __start::@11 to __equinoxe_stage_flight_start [phi:__start::@11->__equinoxe_stage_flight_start]
    jsr equinoxe_stage_flight.__equinoxe_stage_flight_start
    // [26] phi from __start::@11 to __start::@12 [phi:__start::@11->__start::@12]
    // __start::@12
    // [27] call __equinoxe_enemy_start
    // [159] phi from __start::@12 to __equinoxe_enemy_start [phi:__start::@12->__equinoxe_enemy_start]
    jsr equinoxe_enemy.__equinoxe_enemy_start
    // [28] phi from __start::@12 to __start::@13 [phi:__start::@12->__start::@13]
    // __start::@13
    // [29] call __equinoxe_collision_start
    // [161] phi from __start::@13 to __equinoxe_collision_start [phi:__start::@13->__equinoxe_collision_start]
    jsr equinoxe_collision.__equinoxe_collision_start
    // [30] phi from __start::@13 to __start::@14 [phi:__start::@13->__start::@14]
    // __start::@14
    // [31] call __cx16_file_start
    // [163] phi from __start::@14 to __cx16_file_start [phi:__start::@14->__cx16_file_start]
    jsr cx16_file.__cx16_file_start
    // [32] phi from __start::@14 to __start::@15 [phi:__start::@14->__start::@15]
    // __start::@15
    // [33] call main
    jsr main
    // __start::@return
    // [34] return 
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
    // [36] BROM = irq_vsync::bank_set_brom1_bank#0 -- vbuz1=vbuc1 
    lda #bank_set_brom1_bank
    sta.z BROM
    // irq_vsync::vera_display_set_border_color1
    // *VERA_CTRL &= 0b10000001
    // [37] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [38] *VERA_DC_BORDER = YELLOW -- _deref_pbuc1=vbuc2 
    lda #YELLOW
    sta VERA_DC_BORDER
    // irq_vsync::bank_push_set_bram1
    // asm
    // asm { lda$00 pha  }
    lda.z 0
    pha
    // BRAM = bank
    // [40] BRAM = irq_vsync::bank_push_set_bram1_bank#0 -- vbuz1=vbuc1 
    lda #bank_push_set_bram1_bank
    sta.z BRAM
    // irq_vsync::vera_display_set_border_color2
    // *VERA_CTRL &= 0b10000001
    // [41] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [42] *VERA_DC_BORDER = BLUE -- _deref_pbuc1=vbuc2 
    lda #BLUE
    sta VERA_DC_BORDER
    // [43] phi from irq_vsync::vera_display_set_border_color2 to irq_vsync::@3 [phi:irq_vsync::vera_display_set_border_color2->irq_vsync::@3]
    // irq_vsync::@3
    // collision_init()
    // [44] callexecute collision_init  -- call_var_near 
    jsr equinoxe_collision.collision_init
    // cx16_mouse_get()
    // [45] call cx16_mouse_get
    // cx16_mouse_scan(); 
    jsr cx16_mouse_get
    // irq_vsync::@9
    // unsigned char tickupdate = game.ticksync & 0x01
    // [46] irq_vsync::tickupdate#0 = *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC) & 1 -- vbuaa=_deref_pbuc1_band_vbuc2 
    lda #1
    and game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC
    // if(!tickupdate)
    // [47] if(0!=irq_vsync::tickupdate#0) goto irq_vsync::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // irq_vsync::@2
    // stage_logic(game.tickstage)
    // [48] stage_logic::tickstage#0 = *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE) -- vbuxx=_deref_pbuc1 
    ldx game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE
    // [49] call stage_logic
    // [261] phi from irq_vsync::@2 to stage_logic [phi:irq_vsync::@2->stage_logic]
    // [261] phi stage_logic::tickstage#2 = stage_logic::tickstage#0 [phi:irq_vsync::@2->stage_logic#0] -- call_phi_close_cx16_ram 
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
    // irq_vsync::@10
    // game.tickstage++;
    // [50] *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE) = ++ *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSTAGE
    // irq_vsync::@1
  __b1:
    // game.ticksync++;
    // [51] *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC) = ++ *((char *)&game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc game+OFFSET_STRUCT_EQUINOXE_GAME_T_TICKSYNC
    // irq_vsync::vera_display_set_border_color3
    // *VERA_CTRL &= 0b10000001
    // [52] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [53] *VERA_DC_BORDER = LIGHT_BLUE -- _deref_pbuc1=vbuc2 
    lda #LIGHT_BLUE
    sta VERA_DC_BORDER
    // [54] phi from irq_vsync::vera_display_set_border_color3 to irq_vsync::@4 [phi:irq_vsync::vera_display_set_border_color3->irq_vsync::@4]
    // irq_vsync::@4
    // player_logic()
    // [55] call player_logic -- call_phi_close_cx16_ram 
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
    // [56] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [57] *VERA_DC_BORDER = YELLOW -- _deref_pbuc1=vbuc2 
    lda #YELLOW
    sta VERA_DC_BORDER
    // [58] phi from irq_vsync::vera_display_set_border_color4 to irq_vsync::@5 [phi:irq_vsync::vera_display_set_border_color4->irq_vsync::@5]
    // irq_vsync::@5
    // bullet_logic()
    // [59] call bullet_logic -- call_phi_close_cx16_ram 
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
    // [60] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [61] *VERA_DC_BORDER = PINK -- _deref_pbuc1=vbuc2 
    lda #PINK
    sta VERA_DC_BORDER
    // [62] phi from irq_vsync::vera_display_set_border_color5 to irq_vsync::@6 [phi:irq_vsync::vera_display_set_border_color5->irq_vsync::@6]
    // irq_vsync::@6
    // enemy_logic()
    // [63] callexecute enemy_logic  -- call_var_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #8
    sta.z 0
    lda.z $ff
    jsr equinoxe_enemy.enemy_logic
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // irq_vsync::vera_display_set_border_color6
    // *VERA_CTRL &= 0b10000001
    // [64] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [65] *VERA_DC_BORDER = WHITE -- _deref_pbuc1=vbuc2 
    lda #WHITE
    sta VERA_DC_BORDER
    // [66] phi from irq_vsync::vera_display_set_border_color6 to irq_vsync::@7 [phi:irq_vsync::vera_display_set_border_color6->irq_vsync::@7]
    // irq_vsync::@7
    // collision_detect()
    // [67] callexecute collision_detect  -- call_var_near 
    jsr equinoxe_collision.collision_detect
    // irq_vsync::vera_display_set_border_color7
    // *VERA_CTRL &= 0b10000001
    // [68] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [69] *VERA_DC_BORDER = GREY -- _deref_pbuc1=vbuc2 
    lda #GREY
    sta VERA_DC_BORDER
    // [70] phi from irq_vsync::vera_display_set_border_color7 to irq_vsync::@8 [phi:irq_vsync::vera_display_set_border_color7->irq_vsync::@8]
    // irq_vsync::@8
    // flight_draw()
    // [71] callexecute flight_draw  -- call_var_near 
    jsr equinoxe_flightengine.flight_draw
    // *VERA_ISR = 1
    // [72] *VERA_ISR = 1 -- _deref_pbuc1=vbuc2 
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
    // [74] *VERA_CTRL = *VERA_CTRL & $81 -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #$81
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_BORDER = color
    // [75] *VERA_DC_BORDER = BLACK -- _deref_pbuc1=vbuc2 
    lda #BLACK
    sta VERA_DC_BORDER
    // irq_vsync::@return
    // }
    // [76] return 
    // interrupt(isr_rom_sys_cx16_exit) -- isr_rom_sys_cx16_exit 
    jmp (isr_vsync)
}
  // cx16_irq_reset
// void cx16_irq_reset()
cx16_irq_reset: {
    // isr_vsync = *(IRQ_TYPE*)0x0314
    // [77] isr_vsync = *((void (**)()) 788) -- pprm1=_deref_qprc1 
    lda $314
    sta isr_vsync
    lda $314+1
    sta isr_vsync+1
    // cx16_irq_reset::@return
    // }
    // [78] return 
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
    .label cx16_k_screen_set_charset1_offset = $56
    // cx16_k_screen_set_charset(3, (char *)0)
    // [165] main::cx16_k_screen_set_charset1_charset = 3 -- vbum1=vbuc1 
    lda #3
    sta cx16_k_screen_set_charset1_charset
    // [166] main::cx16_k_screen_set_charset1_offset = (char *) 0 -- pbuz1=pbuc1 
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
    // [168] BROM = CX16_ROM_KERNAL -- vbuz1=vbuc1 
    lda #CX16_ROM_KERNAL
    sta.z BROM
    // main::vera_layer0_hide1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [169] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER0_ENABLE
    // [170] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER0_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER0_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [171] phi from main::vera_layer0_hide1 to main::@4 [phi:main::vera_layer0_hide1->main::@4]
    // main::@4
    // vera_layer1_hide()
    // [172] call vera_layer1_hide
    jsr vera_layer1_hide
    // [173] phi from main::@4 to main::@9 [phi:main::@4->main::@9]
    // main::@9
    // vera_petscii_init()
    // [174] callexecute vera_petscii_init  -- call_var_near 
    jsr equinoxe_layers.vera_petscii_init
    // scroll(1)
    // [175] scroll::onoff = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_conio.scroll.onoff
    // [176] callexecute scroll  -- call_var_near 
    jsr lib_conio.scroll
    // equinoxe_init()
    // [177] call equinoxe_init
  // music = fopen("music.bin","r");
    // [407] phi from main::@9 to equinoxe_init [phi:main::@9->equinoxe_init]
    jsr equinoxe_init
    // main::@10
    // bram_heap_bram_bank_init(BANK_HEAP_BRAM)
    // [178] bram_heap_bram_bank_init::bram_bank = $f -- vbum1=vbuc1 
    // We initialize the Commander X16 BRAM heap manager. This manages dynamically the memory space in banked ram as a real heap.
    lda #$f
    sta lib_bramheap.bram_heap_bram_bank_init.bram_bank
    // [179] callexecute bram_heap_bram_bank_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_bram_bank_init
    // bram_heap_segment_init(0, 0x10, (bram_ptr_t)0xA000, 0x3C, (bram_ptr_t)0xA000)
    // [180] bram_heap_segment_init::s = 0 -- vbum1=vbuc1 
    // BREAKPOINT
    lda #0
    sta lib_bramheap.bram_heap_segment_init.s
    // [181] bram_heap_segment_init::bram_bank_floor = $10 -- vbum1=vbuc1 
    lda #$10
    sta lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [182] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [183] bram_heap_segment_init::bram_bank_ceil = $3c -- vbum1=vbuc1 
    lda #$3c
    sta lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [184] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [185] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // bram_heap_segment_init(1, 0x3C, (bram_ptr_t)0xA000, 0x3F, (bram_ptr_t)0xA000)
    // [186] bram_heap_segment_init::s = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_bramheap.bram_heap_segment_init.s
    // [187] bram_heap_segment_init::bram_bank_floor = $3c -- vbum1=vbuc1 
    lda #$3c
    sta lib_bramheap.bram_heap_segment_init.bram_bank_floor
    // [188] bram_heap_segment_init::bram_ptr_floor = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_floor+1
    // [189] bram_heap_segment_init::bram_bank_ceil = $3f -- vbum1=vbuc1 
    lda #$3f
    sta lib_bramheap.bram_heap_segment_init.bram_bank_ceil
    // [190] bram_heap_segment_init::bram_ptr_ceil = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil
    lda #>$a000
    sta.z lib_bramheap.bram_heap_segment_init.bram_ptr_ceil+1
    // [191] callexecute bram_heap_segment_init  -- call_var_near 
    jsr lib_bramheap.bram_heap_segment_init
    // vera_heap_bram_bank_init(BANK_VERA_HEAP)
    // [192] vera_heap_bram_bank_init::bram_bank = 1 -- vbum1=vbuc1 
    // We intialize the Commander X16 VERA heap manager. This manages dynamically the memory space in vera ram as a real heap.
    lda #1
    sta lib_veraheap.vera_heap_bram_bank_init.bram_bank
    // [193] callexecute vera_heap_bram_bank_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_bram_bank_init
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_TILES, FLOOR_TILE_BANK_VRAM, FLOOR_TILE_OFFSET_VRAM, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM)
    // [194] vera_heap_segment_init::s = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_veraheap.vera_heap_segment_init.s
    // [195] vera_heap_segment_init::vram_bank_floor = 0 -- vbum1=vbuc1 
    sta lib_veraheap.vera_heap_segment_init.vram_bank_floor
    // [196] vera_heap_segment_init::vram_offset_floor = 0 -- vwum1=vbuc1 
    sta lib_veraheap.vera_heap_segment_init.vram_offset_floor
    sta lib_veraheap.vera_heap_segment_init.vram_offset_floor+1
    // [197] vera_heap_segment_init::vram_bank_ceil = 0 -- vbum1=vbuc1 
    sta lib_veraheap.vera_heap_segment_init.vram_bank_ceil
    // [198] vera_heap_segment_init::vram_offset_ceil = $5000 -- vwum1=vwuc1 
    lda #<$5000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_ceil
    lda #>$5000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_ceil+1
    // [199] callexecute vera_heap_segment_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_segment_init
    // vera_heap_segment_init(VERA_HEAP_SEGMENT_SPRITES, SPRITE_BANK_VRAM, SPRITE_OFFSET_VRAM, FLOOR_MAP1_BANK_VRAM, FLOOR_MAP1_OFFSET_VRAM)
    // [200] vera_heap_segment_init::s = 1 -- vbum1=vbuc1 
    // FLOOR_TILE segment for tiles of various sizes and types
    lda #1
    sta lib_veraheap.vera_heap_segment_init.s
    // [201] vera_heap_segment_init::vram_bank_floor = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_veraheap.vera_heap_segment_init.vram_bank_floor
    // [202] vera_heap_segment_init::vram_offset_floor = $5000 -- vwum1=vwuc1 
    lda #<$5000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_floor
    lda #>$5000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_floor+1
    // [203] vera_heap_segment_init::vram_bank_ceil = 1 -- vbum1=vbuc1 
    lda #1
    sta lib_veraheap.vera_heap_segment_init.vram_bank_ceil
    // [204] vera_heap_segment_init::vram_offset_ceil = $b000 -- vwum1=vwuc1 
    lda #<$b000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_ceil
    lda #>$b000
    sta lib_veraheap.vera_heap_segment_init.vram_offset_ceil+1
    // [205] callexecute vera_heap_segment_init  -- call_var_near 
    jsr lib_veraheap.vera_heap_segment_init
    // stage_reset()
    // [206] call stage_reset -- call_phi_close_cx16_ram 
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
    // [207] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTART = start
    // [208] *VERA_DC_HSTART = main::vera_display_set_hstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstart1_start
    sta VERA_DC_HSTART
    // main::vera_display_set_hstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [209] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_HSTOP = stop
    // [210] *VERA_DC_HSTOP = main::vera_display_set_hstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_hstop1_stop
    sta VERA_DC_HSTOP
    // main::vera_display_set_vstart1
    // *VERA_CTRL |= VERA_DCSEL
    // [211] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTART = start
    // [212] *VERA_DC_VSTART = main::vera_display_set_vstart1_start#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstart1_start
    sta VERA_DC_VSTART
    // main::vera_display_set_vstop1
    // *VERA_CTRL |= VERA_DCSEL
    // [213] *VERA_CTRL = *VERA_CTRL | VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_DCSEL
    ora VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VSTOP = stop
    // [214] *VERA_DC_VSTOP = main::vera_display_set_vstop1_stop#0 -- _deref_pbuc1=vbuc2 
    lda #vera_display_set_vstop1_stop
    sta VERA_DC_VSTOP
    // [215] phi from main::vera_display_set_vstop1 to main::@5 [phi:main::vera_display_set_vstop1->main::@5]
    // main::@5
    // stage_logic(0)
    // [216] call stage_logic
    // [261] phi from main::@5 to stage_logic [phi:main::@5->stage_logic]
    // [261] phi stage_logic::tickstage#2 = 0 [phi:main::@5->stage_logic#0] -- call_phi_close_cx16_ram 
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
    // [217] scroll::onoff = 0 -- vbum1=vbuc1 
    lda #0
    sta lib_conio.scroll.onoff
    // [218] callexecute scroll  -- call_var_near 
    jsr lib_conio.scroll
    // main::cbm_k_clrchn1
    // asm
    // asm { jsrCBM_CLRCHN  }
    jsr CBM_CLRCHN
    // [220] phi from main::@1 main::cbm_k_clrchn1 to main::@1 [phi:main::@1/main::cbm_k_clrchn1->main::@1]
    // main::@1
  __b1:
    // kbhit()
    // [221] callexecute kbhit  -- call_var_near 
    jsr lib_conio.kbhit
    // [222] main::$29 = kbhit::return -- vbuaa=vbum1 
    lda lib_conio.kbhit.return
    // while(!kbhit())
    // [223] if(0==main::$29) goto main::@1 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b1
    // main::SEI1
    // asm
    // asm { sei  }
    sei
    // [225] phi from main::SEI1 to main::@6 [phi:main::SEI1->main::@6]
    // main::@6
    // cx16_irq_relay(&irq_vsync)
    // [226] call cx16_irq_relay
    jsr cx16_irq_relay
    // main::@12
    // *VERA_IEN = VERA_VSYNC | 0x80
    // [227] *VERA_IEN = VERA_VSYNC|$80 -- _deref_pbuc1=vbuc2 
    // *KERNEL_IRQ = &irq_vsync;
    lda #VERA_VSYNC|$80
    sta VERA_IEN
    // *VERA_IRQLINE_L = 0xFF
    // [228] *VERA_IRQLINE_L = $ff -- _deref_pbuc1=vbuc2 
    lda #$ff
    sta VERA_IRQLINE_L
    // main::CLI1
    // asm
    // asm { cli  }
    cli
    // main::@7
    // cx16_mouse_config(0xFF, 80, 60)
    // [230] cx16_mouse_config::visible = $ff -- vbum1=vbuc1 
    sta cx16_mouse_config.visible
    // [231] cx16_mouse_config::scalex = $50 -- vbum1=vbuc1 
    lda #$50
    sta cx16_mouse_config.scalex
    // [232] cx16_mouse_config::scaley = $3c -- vbum1=vbuc1 
    lda #$3c
    sta cx16_mouse_config.scaley
    // [233] call cx16_mouse_config
    jsr cx16_mouse_config
    // [234] phi from main::@7 to main::@13 [phi:main::@7->main::@13]
    // main::@13
    // cx16_mouse_get()
    // [235] call cx16_mouse_get
    jsr cx16_mouse_get
    // main::vera_sprites_show1
    // *VERA_CTRL &= ~VERA_DCSEL
    // [236] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE
    // [237] *VERA_DC_VIDEO = *VERA_DC_VIDEO | VERA_SPRITES_ENABLE -- _deref_pbuc1=_deref_pbuc1_bor_vbuc2 
    lda #VERA_SPRITES_ENABLE
    ora VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // [238] phi from main::vera_sprites_show1 to main::@8 [phi:main::vera_sprites_show1->main::@8]
    // main::@8
    // volatile unsigned char ch = kbhit()
    // [239] callexecute kbhit  -- call_var_near 
    jsr lib_conio.kbhit
    // [240] main::ch = kbhit::return -- vbum1=vbum2 
    lda lib_conio.kbhit.return
    sta ch
    // main::@2
  __b2:
    // while (ch != 'x')
    // [241] if(main::ch!='x'pm) goto main::@3 -- vbum1_neq_vbuc1_then_la1 
  .encoding "petscii_mixed"
    lda #'x'
    cmp ch
    bne __b3
    // main::bank_set_brom2
    // BROM = bank
    // [242] BROM = CX16_ROM_BASIC -- vbuz1=vbuc1 
    lda #CX16_ROM_BASIC
    sta.z BROM
    // main::@return
    // }
    // [243] return 
    rts
    // [244] phi from main::@2 to main::@3 [phi:main::@2->main::@3]
    // main::@3
  __b3:
    // kbhit()
    // [245] callexecute kbhit  -- call_var_near 
    jsr lib_conio.kbhit
    // [246] main::$32 = kbhit::return -- vbuaa=vbum1 
    lda lib_conio.kbhit.return
    // ch=kbhit()
    // [247] main::ch = main::$32 -- vbum1=vbuaa 
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
    // [248] cx16_mouse_get::status = 0 -- vbum1=vbuc1 
    lda #0
    sta status
    // __address(0xfc) unsigned int x
    // [249] cx16_mouse_get::x = 0 -- vwuz1=vwuc1 
    sta.z x
    sta.z x+1
    // __address(0xfe) unsigned int y
    // [250] cx16_mouse_get::y = 0 -- vwuz1=vwuc1 
    sta.z y
    sta.z y+1
    // if(!cx16_mouse.wait)
    // [251] if(0!=*((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT)) goto cx16_mouse_get::@1 -- 0_neq__deref_pbuc1_then_la1 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT
    bne __b1
    // cx16_mouse_get::@2
    // cx16_mouse.px = cx16_mouse.x
    // [252] *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX) = *((unsigned int *)&cx16_mouse) -- _deref_pwuc1=_deref_pwuc2 
    lda cx16_mouse
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX
    lda cx16_mouse+1
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX+1
    // cx16_mouse.py = cx16_mouse.y
    // [253] *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PY) = *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y) -- _deref_pwuc1=_deref_pwuc2 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PY
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y+1
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PY+1
    // cx16_mouse.wait = 4
    // [254] *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT) = 4 -- _deref_pbuc1=vbuc2 
    lda #4
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT
    // cx16_mouse_get::@1
  __b1:
    // cx16_mouse.wait--;
    // [255] *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT) = -- *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_WAIT
    // asm
    // asm { ldx#$fc jsrCX16_MOUSE_GET stastatus  }
    ldx #$fc
    jsr CX16_MOUSE_GET
    sta status
    // cx16_mouse.x = x
    // [257] *((unsigned int *)&cx16_mouse) = cx16_mouse_get::x -- _deref_pwuc1=vwuz1 
    lda.z x
    sta cx16_mouse
    lda.z x+1
    sta cx16_mouse+1
    // cx16_mouse.y = y
    // [258] *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y) = cx16_mouse_get::y -- _deref_pwuc1=vwuz1 
    lda.z y
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y
    lda.z y+1
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y+1
    // cx16_mouse.status = status
    // [259] *((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS) = cx16_mouse_get::status -- _deref_pbuc1=vbum1 
    lda status
    sta cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS
    // cx16_mouse_get::@return
    // }
    // [260] return 
    rts
  .segment Data
    status: .byte 0
}
.segment CodeEngineStages
  // stage_logic
// void stage_logic(__register(X) char tickstage)
// __bank(cx16_ram, 3) 
stage_logic: {
    .label stage_playbook_ptr1_stage_playbooks_b = $44
    .label stage_playbook_ptr1_return = $48
    .label stage_scenario_ptr1_stage_scenarios_b = $44
    .label stage_scenario_ptr1_return = $48
    .label stage_playbook_ptr2_stage_playbooks_b = $44
    .label stage_playbook_ptr2_return = $48
    .label stage_player_ptr_b = $44
    .label stage_engine_ptr_b = $54
    // if(stage.playbook_current < stage.script_b.playbook_total_b)
    // [262] if(*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT)>=*((char *)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B)) goto stage_logic::@1 -- _deref_pwuc1_ge__deref_pbuc2_then_la1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    bne __b1
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    cmp equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B
    bcs __b1
  !:
    // stage_logic::@2
    // tickstage & 0x03
    // [263] stage_logic::$3 = stage_logic::tickstage#2 & 3 -- vbuaa=vbuxx_band_vbuc1 
    txa
    and #3
    // if(!(tickstage & 0x03))
    // [264] if(0!=stage_logic::$3) goto stage_logic::@1 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b1
    // [265] phi from stage_logic::@2 to stage_logic::@4 [phi:stage_logic::@2->stage_logic::@4]
    // [265] phi stage_logic::w#10 = 0 [phi:stage_logic::@2->stage_logic::@4#0] -- vbum1=vbuc1 
    lda #0
    sta w
  // BREAKPOINT
    // stage_logic::@4
  __b4:
    // for(__mem unsigned char w=0; w<8; w++)
    // [266] if(stage_logic::w#10<8) goto stage_logic::@5 -- vbum1_lt_vbuc1_then_la1 
    lda w
    cmp #8
    bcs !__b5+
    jmp __b5
  !__b5:
    // [267] phi from stage_logic::@4 to stage_logic::@14 [phi:stage_logic::@4->stage_logic::@14]
    // [267] phi stage_logic::w1#2 = 0 [phi:stage_logic::@4->stage_logic::@14#0] -- vbum1=vbuc1 
    lda #0
    sta w1
    // stage_logic::@14
  __b14:
    // for(unsigned char w=0; w<8; w++)
    // [268] if(stage_logic::w1#2<8) goto stage_logic::@15 -- vbum1_lt_vbuc1_then_la1 
    lda w1
    cmp #8
    bcs !__b15+
    jmp __b15
  !__b15:
    // stage_logic::@16
    // if(stage.scenario_current >= stage.scenario_total)
    // [269] if(*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT)<*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL)) goto stage_logic::@1 -- _deref_pwuc1_lt__deref_pwuc2_then_la1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT+1
    cmp equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL+1
    bcc __b1
    bne !+
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT
    cmp equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL
    bcc __b1
  !:
    // stage_logic::@23
    // if(stage.playbook_current < stage.script_b.playbook_total_b)
    // [270] if(*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT)>=*((char *)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B)) goto stage_logic::@1 -- _deref_pwuc1_ge__deref_pbuc2_then_la1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    bne __b1
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    cmp equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B
    bcs __b1
  !:
    // stage_logic::@24
    // stage.scenario_current = 0
    // [271] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT) = 0 -- _deref_pwuc1=vbuc2 
    // stage.playbook_current++;
    // stage_playbook_t* stage_playbook = stage.script_b.playbooks_b;
    // stage.current_playbook = stage_playbook[stage.playbook_current];
    // stage.scenario_total = stage.current_playbook.scenario_total_b;
    lda #<0
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT+1
    // stage_logic::@1
  __b1:
    // if(stage.player_respawn)
    // [272] if(0==*((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN)) goto stage_logic::@return -- 0_eq__deref_pbuc1_then_la1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN
    beq __breturn
    // stage_logic::@3
    // stage.player_respawn--;
    // [273] *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN) = -- *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN) -- _deref_pbuc1=_dec__deref_pbuc1 
    dec equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN
    // if(!stage.player_respawn)
    // [274] if(0!=*((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN)) goto stage_logic::@return -- 0_neq__deref_pbuc1_then_la1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYER_RESPAWN
    bne __breturn
    // stage_logic::stage_playbook_ptr2
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [275] stage_logic::stage_playbook_ptr2_stage_playbooks_b#0 = *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) -- pssz1=_deref_qssc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    sta.z stage_playbook_ptr2_stage_playbooks_b
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    sta.z stage_playbook_ptr2_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [276] stage_logic::$57 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_logic__57
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_logic__57+1
    asl stage_logic__57
    rol stage_logic__57+1
    // [277] stage_logic::$58 = stage_logic::$57 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_logic__58
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_logic__58
    lda stage_logic__58+1
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_logic__58+1
    // [278] stage_logic::stage_playbook_ptr2_$1 = stage_logic::$58 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr2_stage_logic__1
    rol stage_playbook_ptr2_stage_logic__1+1
    // [279] stage_logic::stage_playbook_ptr2_return#0 = stage_logic::stage_playbook_ptr2_stage_playbooks_b#0 + stage_logic::stage_playbook_ptr2_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr2_stage_logic__1
    clc
    adc.z stage_playbook_ptr2_stage_playbooks_b
    sta.z stage_playbook_ptr2_return
    lda stage_playbook_ptr2_stage_logic__1+1
    adc.z stage_playbook_ptr2_stage_playbooks_b+1
    sta.z stage_playbook_ptr2_return+1
    // stage_logic::@26
    // stage_player_t* stage_player_ptr_b = stage_playbook_ptr_b->stage_player
    // [280] stage_logic::stage_player_ptr_b#0 = ((stage_player_t **)stage_logic::stage_playbook_ptr2_return#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER
    lda (stage_playbook_ptr2_return),y
    sta.z stage_player_ptr_b
    iny
    lda (stage_playbook_ptr2_return),y
    sta.z stage_player_ptr_b+1
    // stage_engine_t* stage_engine_ptr_b = stage_player_ptr_b->stage_engine
    // [281] stage_logic::stage_engine_ptr_b#0 = ((stage_engine_t **)stage_logic::stage_player_ptr_b#0)[OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE
    lda (stage_player_ptr_b),y
    sta.z stage_engine_ptr_b
    iny
    lda (stage_player_ptr_b),y
    sta.z stage_engine_ptr_b+1
    // player_add(stage_player_ptr_b->player_sprite, stage_engine_ptr_b->engine_sprite)
    // [282] player_add::sprite_player#1 = *((char *)stage_logic::stage_player_ptr_b#0) -- vbuxx=_deref_pbuz1 
    ldy #0
    lda (stage_player_ptr_b),y
    tax
    // [283] player_add::sprite_engine#1 = *((char *)stage_logic::stage_engine_ptr_b#0) -- vbum1=_deref_pbuz2 
    lda (stage_engine_ptr_b),y
    sta player_add.sprite_engine
    // [284] call player_add
    // [455] phi from stage_logic::@26 to player_add [phi:stage_logic::@26->player_add]
    // [455] phi player_add::sprite_engine#2 = player_add::sprite_engine#1 [phi:stage_logic::@26->player_add#0] -- register_copy 
    // [455] phi player_add::sprite_player#2 = player_add::sprite_player#1 [phi:stage_logic::@26->player_add#1] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <player_add
    .byte >player_add
    .byte 9
    // stage_logic::@return
  __breturn:
    // }
    // [285] return 
    rts
    // stage_logic::@15
  __b15:
    // if(wave.finished[w])
    // [286] if(0==((char *)&wave+OFFSET_STRUCT_WAVE_T_FINISHED)[stage_logic::w1#2]) goto stage_logic::@17 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w1
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_FINISHED,y
    cmp #0
    beq __b17
    // stage_logic::@22
    // __mem stage_scenario_index_t new_scenario = wave.scenario[w]
    // [287] stage_logic::$34 = stage_logic::w1#2 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [288] stage_logic::new_scenario#0 = ((unsigned int *)&wave+OFFSET_STRUCT_WAVE_T_SCENARIO)[stage_logic::$34] -- vwum1=pwuc1_derefidx_vbuxx 
    // If there are more scenarios, create new waves based on the scenarios dependent on the finished wave.
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_SCENARIO,x
    sta new_scenario
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_SCENARIO+1,x
    sta new_scenario+1
    // __mem unsigned int wave_scenario = wave.scenario[w]
    // [289] stage_logic::wave_scenario#0 = ((unsigned int *)&wave+OFFSET_STRUCT_WAVE_T_SCENARIO)[stage_logic::$34] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_SCENARIO,x
    sta wave_scenario
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_SCENARIO+1,x
    sta wave_scenario+1
    // [290] phi from stage_logic::@20 stage_logic::@22 to stage_logic::@18 [phi:stage_logic::@20/stage_logic::@22->stage_logic::@18]
  __b2:
    // [290] phi stage_logic::new_scenario#10 = stage_logic::new_scenario#1 [phi:stage_logic::@20/stage_logic::@22->stage_logic::@18#0] -- register_copy 
  // TODO find solution for this loop, maybe with pointers?
    // stage_logic::@18
    // while(new_scenario < stage.scenario_total)
    // [291] if(stage_logic::new_scenario#10<*((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL)) goto stage_logic::stage_playbook_ptr1 -- vwum1_lt__deref_pwuc1_then_la1 
    lda new_scenario+1
    cmp equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL+1
    bcc stage_playbook_ptr1
    bne !+
    lda new_scenario
    cmp equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL
    bcc stage_playbook_ptr1
  !:
    // stage_logic::@19
    // wave.finished[w] = 0
    // [292] ((char *)&wave+OFFSET_STRUCT_WAVE_T_FINISHED)[stage_logic::w1#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy w1
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_FINISHED,y
    // stage_logic::@17
  __b17:
    // for(unsigned char w=0; w<8; w++)
    // [293] stage_logic::w1#1 = ++ stage_logic::w1#2 -- vbum1=_inc_vbum1 
    inc w1
    // [267] phi from stage_logic::@17 to stage_logic::@14 [phi:stage_logic::@17->stage_logic::@14]
    // [267] phi stage_logic::w1#2 = stage_logic::w1#1 [phi:stage_logic::@17->stage_logic::@14#0] -- register_copy 
    jmp __b14
    // stage_logic::stage_playbook_ptr1
  stage_playbook_ptr1:
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [294] stage_logic::stage_playbook_ptr1_stage_playbooks_b#0 = *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) -- pssz1=_deref_qssc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    sta.z stage_playbook_ptr1_stage_playbooks_b
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    sta.z stage_playbook_ptr1_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [295] stage_logic::$54 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_logic__54
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_logic__54+1
    asl stage_logic__54
    rol stage_logic__54+1
    // [296] stage_logic::$55 = stage_logic::$54 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_logic__55
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_logic__55
    lda stage_logic__55+1
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_logic__55+1
    // [297] stage_logic::stage_playbook_ptr1_$1 = stage_logic::$55 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr1_stage_logic__1
    rol stage_playbook_ptr1_stage_logic__1+1
    // [298] stage_logic::stage_playbook_ptr1_return#0 = stage_logic::stage_playbook_ptr1_stage_playbooks_b#0 + stage_logic::stage_playbook_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr1_stage_logic__1
    clc
    adc.z stage_playbook_ptr1_stage_playbooks_b
    sta.z stage_playbook_ptr1_return
    lda stage_playbook_ptr1_stage_logic__1+1
    adc.z stage_playbook_ptr1_stage_playbooks_b+1
    sta.z stage_playbook_ptr1_return+1
    // stage_logic::stage_scenario_ptr1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_ptr_b->scenarios_b
    // [299] stage_logic::stage_scenario_ptr1_stage_scenarios_b#0 = ((stage_scenario_t **)stage_logic::stage_playbook_ptr1_return#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b
    iny
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b+1
    // &stage_scenarios_b[scenario]
    // [300] stage_logic::stage_scenario_ptr1_$1 = stage_logic::new_scenario#10 << 4 -- vwum1=vwum2_rol_4 
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
    // [301] stage_logic::stage_scenario_ptr1_return#0 = stage_logic::stage_scenario_ptr1_stage_scenarios_b#0 + stage_logic::stage_scenario_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_scenario_ptr1_stage_logic__1
    clc
    adc.z stage_scenario_ptr1_stage_scenarios_b
    sta.z stage_scenario_ptr1_return
    lda stage_scenario_ptr1_stage_logic__1+1
    adc.z stage_scenario_ptr1_stage_scenarios_b+1
    sta.z stage_scenario_ptr1_return+1
    // stage_logic::@25
    // unsigned int prev = stage_scenario_ptr_b->prev
    // [302] stage_logic::prev#0 = (unsigned int)((char *)stage_logic::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_PREV] -- vwum1=_word_pbuz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_PREV
    lda (stage_scenario_ptr1_return),y
    sta prev
    lda #0
    sta prev+1
    // if(prev == wave_scenario)
    // [303] if(stage_logic::prev#0!=stage_logic::wave_scenario#0) goto stage_logic::@20 -- vwum1_neq_vwum2_then_la1 
    cmp wave_scenario+1
    bne __b20
    lda prev
    cmp wave_scenario
    bne __b20
    // stage_logic::@21
    // stage.ew+1
    // [304] stage_logic::$21 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_EW) + 1 -- vwum1=_deref_pwuc1_plus_1 
    clc
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_EW
    adc #1
    sta stage_logic__21
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_EW+1
    adc #0
    sta stage_logic__21+1
    // (stage.ew+1) & 0x07
    // [305] stage_logic::$22 = stage_logic::$21 & 7 -- vbuaa=vwum1_band_vbuc1 
    lda #7
    and stage_logic__21
    // stage.ew = (stage.ew+1) & 0x07
    // [306] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_EW) = stage_logic::$22 -- _deref_pwuc1=vbuaa 
    // We create new waves from the scenarios that are dependent on the finished one.
    // There must always be at least one that equals scenario of the previous scenario.
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_EW
    lda #0
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_EW+1
    // stage_copy(stage.ew, new_scenario)
    // [307] stage_copy::ew#1 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_EW) -- vbum1=_deref_pwuc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_EW
    sta stage_copy.ew
    // [308] stage_copy::scenario#1 = stage_logic::new_scenario#10 -- vwum1=vwum2 
    lda new_scenario
    sta stage_copy.scenario
    lda new_scenario+1
    sta stage_copy.scenario+1
    // [309] call stage_copy
    // [499] phi from stage_logic::@21 to stage_copy [phi:stage_logic::@21->stage_copy]
    // [499] phi stage_copy::ew#2 = stage_copy::ew#1 [phi:stage_logic::@21->stage_copy#0] -- register_copy 
    // [499] phi stage_copy::scenario#2 = stage_copy::scenario#1 [phi:stage_logic::@21->stage_copy#1] -- register_copy 
    jsr stage_copy
    // stage_logic::@20
  __b20:
    // new_scenario++;
    // [310] stage_logic::new_scenario#1 = ++ stage_logic::new_scenario#10 -- vwum1=_inc_vwum1 
    inc new_scenario
    bne !+
    inc new_scenario+1
  !:
    jmp __b2
    // stage_logic::@5
  __b5:
    // if(wave.used[w])
    // [311] if(0==((char *)&wave+OFFSET_STRUCT_WAVE_T_USED)[stage_logic::w#10]) goto stage_logic::@6 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_USED,y
    cmp #0
    beq __b6
    // stage_logic::@12
    // if(!wave.wait[w])
    // [312] if(0==((char *)&wave+OFFSET_STRUCT_WAVE_T_WAIT)[stage_logic::w#10]) goto stage_logic::@7 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_WAIT,y
    cmp #0
    beq __b7
    // stage_logic::@13
    // wave.wait[w]--;
    // [313] ((char *)&wave+OFFSET_STRUCT_WAVE_T_WAIT)[stage_logic::w#10] = -- ((char *)&wave+OFFSET_STRUCT_WAVE_T_WAIT)[stage_logic::w#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx w
    dec equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_WAIT,x
    // stage_logic::@6
  __b6:
    // for(__mem unsigned char w=0; w<8; w++)
    // [314] stage_logic::w#1 = ++ stage_logic::w#10 -- vbum1=_inc_vbum1 
    inc w
    // [265] phi from stage_logic::@6 to stage_logic::@4 [phi:stage_logic::@6->stage_logic::@4]
    // [265] phi stage_logic::w#10 = stage_logic::w#1 [phi:stage_logic::@6->stage_logic::@4#0] -- register_copy 
    jmp __b4
    // stage_logic::@7
  __b7:
    // if(wave.enemy_count[w])
    // [315] if(0!=((char *)&wave)[stage_logic::w#10]) goto stage_logic::@8 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    ldy w
    lda equinoxe_waves.wave,y
    cmp #0
    bne __b8
    // stage_logic::@10
    // if(!wave.enemy_alive[w])
    // [316] if(0!=((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE)[stage_logic::w#10]) goto stage_logic::@6 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE,y
    cmp #0
    bne __b6
    // stage_logic::@11
    // wave.used[w] = 0
    // [317] ((char *)&wave+OFFSET_STRUCT_WAVE_T_USED)[stage_logic::w#10] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_USED,y
    // wave.finished[w] = 1
    // [318] ((char *)&wave+OFFSET_STRUCT_WAVE_T_FINISHED)[stage_logic::w#10] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_FINISHED,y
    jmp __b6
    // stage_logic::@8
  __b8:
    // if(wave.enemy_spawn[w])
    // [319] if(0==((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN)[stage_logic::w#10]) goto stage_logic::@6 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy w
    lda equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN,y
    cmp #0
    beq __b6
    // stage_logic::@9
    // stage_enemy_add(w, wave.enemy_sprite[w])
    // [320] stage_enemy_add::w#0 = stage_logic::w#10 -- vbum1=vbum2 
    tya
    sta stage_enemy_add.w
    // [321] stage_enemy_add::enemy_sprite#0 = ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPRITE)[stage_logic::w#10] -- vbuxx=pbuc1_derefidx_vbum1 
    ldx equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPRITE,y
    // [322] call stage_enemy_add
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
    // [323] flight_root::type = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_flightengine.flight_root.type
    // [324] callexecute flight_root  -- call_var_near 
    jsr equinoxe_flightengine.flight_root
    // [325] player_logic::p#0 = flight_root::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_root.return
    sta p
    // [326] phi from player_logic player_logic::@3 to player_logic::@1 [phi:player_logic/player_logic::@3->player_logic::@1]
    // [326] phi player_logic::p#10 = player_logic::p#0 [phi:player_logic/player_logic::@3->player_logic::@1#0] -- register_copy 
    // player_logic::@1
  __b1:
    // while(p)
    // [327] if(0!=player_logic::p#10) goto player_logic::@2 -- 0_neq_vbum1_then_la1 
    lda p
    bne __b2
    // player_logic::@return
    // }
    // [328] return 
    rts
    // player_logic::@2
  __b2:
    // flight_index_t pn = flight_next(p)
    // [329] flight_next::i = player_logic::p#10 -- vbum1=vbum2 
    lda p
    sta equinoxe_flightengine.flight_next.i
    // [330] callexecute flight_next  -- call_var_near 
    jsr equinoxe_flightengine.flight_next
    // [331] player_logic::p#1 = flight_next::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_next.return
    sta p_1
    // if (flight.type[p] == FLIGHT_PLAYER && flight.used[p])
    // [332] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[player_logic::p#10]!=0) goto player_logic::@3 -- pbuc1_derefidx_vbum1_neq_0_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    cmp #0
    bne __b3
    // player_logic::@15
    // [333] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[player_logic::p#10]) goto player_logic::@13 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne __b13
    // player_logic::@3
  __b3:
    // [334] player_logic::p#17 = player_logic::p#1 -- vbum1=vbum2 
    lda p_1
    sta p
    jmp __b1
    // player_logic::@13
  __b13:
    // if (flight.reload[p] > 0)
    // [335] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10]<=0) goto player_logic::@4 -- pbuc1_derefidx_vbum1_le_0_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    cmp #0
    beq __b4
    // player_logic::@14
    // flight.reload[p]--;
    // [336] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10] = -- ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10] -- pbuc1_derefidx_vbum1=_dec_pbuc1_derefidx_vbum1 
    ldx p
    dec equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,x
    // player_logic::@4
  __b4:
    // if (cx16_mouse.status == 1 && flight.reload[p] <= 0)
    // [337] if(*((char *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS)!=1) goto player_logic::@5 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #1
    cmp cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_STATUS
    bne __b5
    // player_logic::@16
    // [338] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10]<=0) goto player_logic::@9 -- pbuc1_derefidx_vbum1_le_0_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    cmp #0
    bne !__b9+
    jmp __b9
  !__b9:
    // player_logic::@5
  __b5:
    // flight.xi[p] = (unsigned int)cx16_mouse.x
    // [339] player_logic::$25 = player_logic::p#10 << 1 -- vbum1=vbum2_rol_1 
    lda p
    asl
    sta player_logic__25
    // [340] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$25] = *((unsigned int *)&cx16_mouse) -- pwuc1_derefidx_vbum1=_deref_pwuc2 
    tay
    lda cx16_mouse
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,y
    lda cx16_mouse+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,y
    // flight.yi[p] = (unsigned int)cx16_mouse.y
    // [341] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$25] = *((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y) -- pwuc1_derefidx_vbum1=_deref_pwuc2 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,y
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_Y+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,y
    // flight_index_t n = flight.engine[p]
    // [342] player_logic::n#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENGINE)[player_logic::p#10] -- vbum1=pbuc1_derefidx_vbum2 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENGINE,y
    sta n
    // flight.xi[p]+8
    // [343] player_logic::$15 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$25] + 8 -- vwum1=pwuc1_derefidx_vbum2_plus_vbuc2 
    lda #8
    ldy player_logic__25
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,y
    sta player_logic__15
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,y
    adc #0
    sta player_logic__15+1
    // flight.xi[n] = flight.xi[p]+8
    // [344] player_logic::$29 = player_logic::n#0 << 1 -- vbuxx=vbum1_rol_1 
    lda n
    asl
    tax
    // [345] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$29] = player_logic::$15 -- pwuc1_derefidx_vbuxx=vwum1 
    lda player_logic__15
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda player_logic__15+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[p]+32
    // [346] player_logic::$16 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$25] + $20 -- vwum1=pwuc1_derefidx_vbum2_plus_vbuc2 
    lda #$20
    clc
    adc equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,y
    sta player_logic__16
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,y
    adc #0
    sta player_logic__16+1
    // flight.yi[n] = flight.yi[p]+32
    // [347] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$29] = player_logic::$16 -- pwuc1_derefidx_vbuxx=vwum1 
    lda player_logic__16
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda player_logic__16+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // unsigned int x = flight.xi[p]
    // [348] player_logic::x1#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$25] -- vwum1=pwuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,y
    sta x1
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,y
    sta x1+1
    // unsigned int y = flight.yi[p]
    // [349] player_logic::y1#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$25] -- vwum1=pwuc1_derefidx_vbum2 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,y
    sta y1
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,y
    sta y1+1
    // if (x > 640 - 32)
    // [350] if(player_logic::x1#0<=$280-$20) goto player_logic::@7 -- vwum1_le_vwuc1_then_la1 
    lda x1+1
    cmp #>$280-$20
    bne !+
    lda x1
    cmp #<$280-$20
  !:
    // [351] phi from player_logic::@5 to player_logic::@11 [phi:player_logic::@5->player_logic::@11]
    // player_logic::@11
    // player_logic::@7
    // if (y > 480 - 32)
    // [352] if(player_logic::y1#0<=$1e0-$20) goto player_logic::@8 -- vwum1_le_vwuc1_then_la1 
    lda y1+1
    cmp #>$1e0-$20
    bne !+
    lda y1
    cmp #<$1e0-$20
  !:
    // [353] phi from player_logic::@7 to player_logic::@12 [phi:player_logic::@7->player_logic::@12]
    // player_logic::@12
    // player_logic::@8
    // unsigned char ap = flight.animate[p]
    // [354] player_logic::ap#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_logic::p#10] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // animate_player(ap, (signed int)cx16_mouse.x, (signed int)cx16_mouse.px)
    // [355] animate_player::a = player_logic::ap#0 -- vbuz1=vbuaa 
    sta.z equinoxe_animate.animate_player.a
    // [356] animate_player::x = (int)*((unsigned int *)&cx16_mouse) -- vwsz1=_deref_pwsc1 
    lda cx16_mouse
    sta.z equinoxe_animate.animate_player.x
    lda cx16_mouse+1
    sta.z equinoxe_animate.animate_player.x+1
    // [357] animate_player::px = (int)*((unsigned int *)&cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX) -- vwsz1=_deref_pwsc1 
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX
    sta.z equinoxe_animate.animate_player.px
    lda cx16_mouse+OFFSET_STRUCT_CX16_MOUSE_T_PX+1
    sta.z equinoxe_animate.animate_player.px+1
    // [358] callexecute animate_player  -- call_var_near 
    jsr equinoxe_animate.animate_player
    // unsigned char an = flight.animate[n]
    // [359] player_logic::an#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_logic::n#0] -- vbuaa=pbuc1_derefidx_vbum1 
    ldy n
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // animate_logic(an)
    // [360] animate_logic::a = player_logic::an#0 -- vbuz1=vbuaa 
    sta.z equinoxe_animate.animate_logic.a
    // [361] callexecute animate_logic  -- call_var_near 
    jsr equinoxe_animate.animate_logic
    // collision_insert(p)
    // [362] collision_insert::f = player_logic::p#10 -- vbuz1=vbum2 
    lda p
    sta.z equinoxe_collision.collision_insert.f
    // [363] callexecute collision_insert  -- call_var_near 
    jsr equinoxe_collision.collision_insert
    jmp __b3
    // player_logic::@9
  __b9:
    // unsigned int x = flight.xi[p]
    // [364] player_logic::$35 = player_logic::p#10 << 1 -- vbuxx=vbum1_rol_1 
    lda p
    asl
    tax
    // [365] player_logic::x#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_logic::$35] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    sta x
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    sta x+1
    // unsigned int y = flight.yi[p]
    // [366] player_logic::y#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_logic::$35] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    sta y
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    sta y+1
    // if (flight.firegun[p])
    // [367] if(0==((char *)&flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN)[player_logic::p#10]) goto player_logic::@6 -- 0_eq_pbuc1_derefidx_vbum1_then_la1 
    ldy p
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN,y
    cmp #0
    beq __b6
    // player_logic::@10
    // x += (signed char)16
    // [368] player_logic::x#1 = player_logic::x#0 + $10 -- vwum1=vwum1_plus_vbsc1 
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
    // [369] phi from player_logic::@10 player_logic::@9 to player_logic::@6 [phi:player_logic::@10/player_logic::@9->player_logic::@6]
    // [369] phi player_logic::x#2 = player_logic::x#1 [phi:player_logic::@10/player_logic::@9->player_logic::@6#0] -- register_copy 
    // player_logic::@6
  __b6:
    // flight.firegun[p] ^ 1
    // [370] player_logic::$13 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN)[player_logic::p#10] ^ 1 -- vbuaa=pbuc1_derefidx_vbum1_bxor_vbuc2 
    lda #1
    ldy p
    eor equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN,y
    // flight.firegun[p] = flight.firegun[p] ^ 1
    // [371] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN)[player_logic::p#10] = player_logic::$13 -- pbuc1_derefidx_vbum1=vbuaa 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN,y
    // flight.reload[p] = 8
    // [372] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_logic::p#10] = 8 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #8
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    // stage_bullet_add(x, y, x, 0, 5, SIDE_PLAYER, b001)
    // [373] stage_bullet_add::sx#0 = player_logic::x#2 -- vwum1=vwum2 
    lda x
    sta stage_bullet_add.sx
    lda x+1
    sta stage_bullet_add.sx+1
    // [374] stage_bullet_add::sy#0 = player_logic::y#0 -- vwum1=vwum2 
    lda y
    sta stage_bullet_add.sy
    lda y+1
    sta stage_bullet_add.sy+1
    // [375] stage_bullet_add::tx#0 = player_logic::x#2 -- vwum1=vwum2 
    lda x
    sta stage_bullet_add.tx
    lda x+1
    sta stage_bullet_add.tx+1
    // [376] call stage_bullet_add -- call_phi_far_cx16_ram 
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
    // [377] flight_root::type = 3 -- vbum1=vbuc1 
    lda #3
    sta equinoxe_flightengine.flight_root.type
    // [378] callexecute flight_root  -- call_var_near 
    jsr equinoxe_flightengine.flight_root
    // [379] bullet_logic::b#0 = flight_root::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_root.return
    sta b
    // [380] phi from bullet_logic bullet_logic::@3 to bullet_logic::@1 [phi:bullet_logic/bullet_logic::@3->bullet_logic::@1]
    // [380] phi bullet_logic::b#2 = bullet_logic::b#0 [phi:bullet_logic/bullet_logic::@3->bullet_logic::@1#0] -- register_copy 
    // bullet_logic::@1
  __b1:
    // while(b)
    // [381] if(0!=bullet_logic::b#2) goto bullet_logic::@2 -- 0_neq_vbum1_then_la1 
    lda b
    bne __b2
    // bullet_logic::@return
    // }
    // [382] return 
    rts
    // bullet_logic::@2
  __b2:
    // flight_index_t bn = flight_next(b)
    // [383] flight_next::i = bullet_logic::b#2 -- vbum1=vbum2 
    lda b
    sta equinoxe_flightengine.flight_next.i
    // [384] callexecute flight_next  -- call_var_near 
    jsr equinoxe_flightengine.flight_next
    // [385] bullet_logic::b#1 = flight_next::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_next.return
    sta b_1
    // if(flight.type[b] == FLIGHT_BULLET && flight.used[b])
    // [386] if(((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[bullet_logic::b#2]!=3) goto bullet_logic::@3 -- pbuc1_derefidx_vbum1_neq_vbuc2_then_la1 
    lda #3
    ldy b
    cmp equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,y
    bne __b3
    // bullet_logic::@7
    // [387] if(0!=((char *)&flight+OFFSET_STRUCT_FLIGHT_T_USED)[bullet_logic::b#2]) goto bullet_logic::@5 -- 0_neq_pbuc1_derefidx_vbum1_then_la1 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_USED,y
    cmp #0
    bne __b5
    // bullet_logic::@3
  __b3:
    // [388] bullet_logic::b#8 = bullet_logic::b#1 -- vbum1=vbum2 
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
    // [390] bullet_logic::$17 = bullet_logic::b#2 << 1 -- vbuxx=vbum1_rol_1 
    lda b
    asl
    tax
    // [391] bullet_logic::x#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[bullet_logic::$17] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    sta x
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    sta x+1
    // unsigned int y = flight.yi[b]
    // [392] bullet_logic::y#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[bullet_logic::$17] -- vwum1=pwuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    sta y
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    sta y+1
    // if(x<640 && y<480 && x<0xFFFF-32 && y<0xFFFF-32)
    // [393] if(bullet_logic::x#0>=$280) goto bullet_logic::@6 -- vwum1_ge_vwuc1_then_la1 
    lda x+1
    cmp #>$280
    bcc !+
    bne __b6
    lda x
    cmp #<$280
    bcs __b6
  !:
    // bullet_logic::@10
    // [394] if(bullet_logic::y#0<$1e0) goto bullet_logic::@9 -- vwum1_lt_vwuc1_then_la1 
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
    // stage_bullet_remove(b)
    // [395] stage_bullet_remove::b = bullet_logic::b#2 -- vbum1=vbum2 
    lda b
    sta equinoxe_stage_flight.stage_bullet_remove.b
    // [396] callexecute stage_bullet_remove  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_stage_flight.stage_bullet_remove
    .byte >equinoxe_stage_flight.stage_bullet_remove
    .byte 3
    jmp __b3
    // bullet_logic::@9
  __b9:
    // if(x<640 && y<480 && x<0xFFFF-32 && y<0xFFFF-32)
    // [397] if(bullet_logic::x#0>=$ffff-$20) goto bullet_logic::@6 -- vwum1_ge_vwuc1_then_la1 
    lda x+1
    cmp #>$ffff-$20
    bcc !+
    bne __b6
    lda x
    cmp #<$ffff-$20
    bcs __b6
  !:
    // bullet_logic::@8
    // [398] if(bullet_logic::y#0<$ffff-$20) goto bullet_logic::@4 -- vwum1_lt_vwuc1_then_la1 
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
    // [399] bullet_logic::a = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[bullet_logic::b#2] -- vbum1=pbuc1_derefidx_vbum2 
    //     if(!flight.enabled[b]) {
    // vera_sprite_zdepth(sprite_offset, sprite_cache.zdepth[flight.sprite[b]]);
    //         flight.enabled[b] = 1;
    //     }
    ldy b
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    sta a
    // animate_logic(a)
    // [400] animate_logic::a = bullet_logic::a -- vbuz1=vbum2 
    // 	if(animate_is_waiting(a)) {
    // 		vera_sprite_set_xy(sprite_offset, (signed int)x, (signed int)y);
    // 	} else {
    // 		// vera_sprite_set_xy_and_image_offset(sprite_offset, x, y, sprite_cache.vram_image_offset[(unsigned int)flight.sprite[b]*16+flight.state_animation[b]]);
    // 		vera_sprite_set_xy_and_image_offset(sprite_offset, (signed int)x, (signed int)y, sprite_image_cache_vram(flight.sprite[b], animate_get_state(a)));
    // 	}
    sta.z equinoxe_animate.animate_logic.a
    // [401] callexecute animate_logic  -- call_var_near 
    jsr equinoxe_animate.animate_logic
    // collision_insert(b)
    // [402] collision_insert::f = bullet_logic::b#2 -- vbuz1=vbum2 
    lda b
    sta.z equinoxe_collision.collision_insert.f
    // [403] callexecute collision_insert  -- call_var_near 
    jsr equinoxe_collision.collision_insert
    jmp __b3
  .segment DataEngineBullets
    a: .byte 0
    b: .byte 0
    b_1: .byte 0
    x: .word 0
    y: .word 0
}
.segment Code
  // vera_layer1_hide
/**
 * @brief Hide the layer 1 to be displayed from the screen.
 */
// void vera_layer1_hide()
vera_layer1_hide: {
    // *VERA_CTRL &= ~VERA_DCSEL
    // [404] *VERA_CTRL = *VERA_CTRL & ~VERA_DCSEL -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_DCSEL^$ff
    and VERA_CTRL
    sta VERA_CTRL
    // *VERA_DC_VIDEO &= ~VERA_LAYER1_ENABLE
    // [405] *VERA_DC_VIDEO = *VERA_DC_VIDEO & ~VERA_LAYER1_ENABLE -- _deref_pbuc1=_deref_pbuc1_band_vbuc2 
    lda #VERA_LAYER1_ENABLE^$ff
    and VERA_DC_VIDEO
    sta VERA_DC_VIDEO
    // vera_layer1_hide::@return
    // }
    // [406] return 
    rts
}
  // equinoxe_init
// __mem FILE* music;
// unsigned char music_buffer[1024];
// void equinoxe_init()
equinoxe_init: {
    // fload_bram("stages.bin", BANK_ENGINE_STAGES, (bram_ptr_t)0xA000)
    // [408] call fload_bram
    // [541] phi from equinoxe_init to fload_bram [phi:equinoxe_init->fload_bram]
    // [541] phi fload_bram::filename#10 = equinoxe_init::filename [phi:equinoxe_init->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename
    sta.z fload_bram.filename
    lda #>filename
    sta.z fload_bram.filename+1
    // [541] phi fload_bram::dbank#10 = 3 [phi:equinoxe_init->fload_bram#1] -- vbuxx=vbuc1 
    ldx #3
    jsr fload_bram
    // [409] phi from equinoxe_init to equinoxe_init::@1 [phi:equinoxe_init->equinoxe_init::@1]
    // equinoxe_init::@1
    // fload_bram("bramflight1.bin", BANK_ENGINE_SPRITES, (bram_ptr_t)0xA000)
    // [410] call fload_bram
    // [541] phi from equinoxe_init::@1 to fload_bram [phi:equinoxe_init::@1->fload_bram]
    // [541] phi fload_bram::filename#10 = equinoxe_init::filename1 [phi:equinoxe_init::@1->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename1
    sta.z fload_bram.filename
    lda #>filename1
    sta.z fload_bram.filename+1
    // [541] phi fload_bram::dbank#10 = 4 [phi:equinoxe_init::@1->fload_bram#1] -- vbuxx=vbuc1 
    ldx #4
    jsr fload_bram
    // [411] phi from equinoxe_init::@1 to equinoxe_init::@2 [phi:equinoxe_init::@1->equinoxe_init::@2]
    // equinoxe_init::@2
    // fload_bram("bramfloor1.bin", BANK_ENGINE_FLOOR, (bram_ptr_t)0xA000)
    // [412] call fload_bram
    // [541] phi from equinoxe_init::@2 to fload_bram [phi:equinoxe_init::@2->fload_bram]
    // [541] phi fload_bram::filename#10 = equinoxe_init::filename2 [phi:equinoxe_init::@2->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename2
    sta.z fload_bram.filename
    lda #>filename2
    sta.z fload_bram.filename+1
    // [541] phi fload_bram::dbank#10 = 5 [phi:equinoxe_init::@2->fload_bram#1] -- vbuxx=vbuc1 
    ldx #5
    jsr fload_bram
    // [413] phi from equinoxe_init::@2 to equinoxe_init::@3 [phi:equinoxe_init::@2->equinoxe_init::@3]
    // equinoxe_init::@3
    // fload_bram("veraheap.bin", BANK_VERA_HEAP, (bram_ptr_t)0xA000)
    // [414] call fload_bram
    // [541] phi from equinoxe_init::@3 to fload_bram [phi:equinoxe_init::@3->fload_bram]
    // [541] phi fload_bram::filename#10 = equinoxe_init::filename3 [phi:equinoxe_init::@3->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename3
    sta.z fload_bram.filename
    lda #>filename3
    sta.z fload_bram.filename+1
    // [541] phi fload_bram::dbank#10 = 1 [phi:equinoxe_init::@3->fload_bram#1] -- vbuxx=vbuc1 
    ldx #1
    jsr fload_bram
    // [415] phi from equinoxe_init::@3 to equinoxe_init::@4 [phi:equinoxe_init::@3->equinoxe_init::@4]
    // equinoxe_init::@4
    // flight_init()
    // [416] callexecute flight_init  -- call_var_near 
    jsr equinoxe_flightengine.flight_init
    // fload_bram("players.bin", BANK_ENGINE_PLAYERS, (bram_ptr_t)0xA000)
    // [417] call fload_bram
    // [541] phi from equinoxe_init::@4 to fload_bram [phi:equinoxe_init::@4->fload_bram]
    // [541] phi fload_bram::filename#10 = equinoxe_init::filename4 [phi:equinoxe_init::@4->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename4
    sta.z fload_bram.filename
    lda #>filename4
    sta.z fload_bram.filename+1
    // [541] phi fload_bram::dbank#10 = 9 [phi:equinoxe_init::@4->fload_bram#1] -- vbuxx=vbuc1 
    ldx #9
    jsr fload_bram
    // [418] phi from equinoxe_init::@4 to equinoxe_init::@5 [phi:equinoxe_init::@4->equinoxe_init::@5]
    // equinoxe_init::@5
    // fload_bram("enemies.bin", BANK_ENGINE_ENEMIES, (bram_ptr_t)0xA000)
    // [419] call fload_bram
    // [541] phi from equinoxe_init::@5 to fload_bram [phi:equinoxe_init::@5->fload_bram]
    // [541] phi fload_bram::filename#10 = equinoxe_init::filename5 [phi:equinoxe_init::@5->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename5
    sta.z fload_bram.filename
    lda #>filename5
    sta.z fload_bram.filename+1
    // [541] phi fload_bram::dbank#10 = 8 [phi:equinoxe_init::@5->fload_bram#1] -- vbuxx=vbuc1 
    ldx #8
    jsr fload_bram
    // [420] phi from equinoxe_init::@5 to equinoxe_init::@6 [phi:equinoxe_init::@5->equinoxe_init::@6]
    // equinoxe_init::@6
    // fload_bram("bullets.bin", BANK_ENGINE_BULLETS, (bram_ptr_t)0xA000)
    // [421] call fload_bram
    // [541] phi from equinoxe_init::@6 to fload_bram [phi:equinoxe_init::@6->fload_bram]
    // [541] phi fload_bram::filename#10 = equinoxe_init::filename6 [phi:equinoxe_init::@6->fload_bram#0] -- pbuz1=pbuc1 
    lda #<filename6
    sta.z fload_bram.filename
    lda #>filename6
    sta.z fload_bram.filename+1
    // [541] phi fload_bram::dbank#10 = 7 [phi:equinoxe_init::@6->fload_bram#1] -- vbuxx=vbuc1 
    ldx #7
    jsr fload_bram
    // [422] phi from equinoxe_init::@6 to equinoxe_init::@7 [phi:equinoxe_init::@6->equinoxe_init::@7]
    // equinoxe_init::@7
    // animate_init()
    // [423] callexecute animate_init  -- call_var_near 
    jsr equinoxe_animate.animate_init
    // memset(&stage, 0, sizeof(stage_t))
    // [424] call memset
    // [561] phi from equinoxe_init::@7 to memset [phi:equinoxe_init::@7->memset]
    jsr memset
    // [425] phi from equinoxe_init::@7 to equinoxe_init::@8 [phi:equinoxe_init::@7->equinoxe_init::@8]
    // equinoxe_init::@8
    // lru_cache_init()
    // [426] callexecute lru_cache_init  -- call_var_near 
    // Initialize the cache in vram for the sprite animations.
    jsr lib_lru_cache.lru_cache_init
    // equinoxe_init::@return
    // }
    // [427] return 
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
    .label stage_player = $46
    .label stage_engine = $52
    // palette_init(BANK_ENGINE_PALETTE)
    // [428] palette_init::bram_bank = 6 -- vbum1=vbuc1 
    lda #6
    sta equinoxe_palette.palette_init.bram_bank
    // [429] callexecute palette_init  -- call_var_near 
    jsr equinoxe_palette.palette_init
    // [430] phi from stage_reset to stage_reset::@1 [phi:stage_reset->stage_reset::@1]
    // stage_reset::@1
    // memset(&stage, 0, sizeof(stage_t))
    // [431] call memset
  // #ifdef __ENEMY
  //     enemy_init();
  // #endif
    // [561] phi from stage_reset::@1 to memset [phi:stage_reset::@1->memset]
    jsr memset
    // stage_reset::@2
    // stage.script_b.playbook_total_b = 1
    // [432] *((char *)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B) = 1 -- _deref_pbuc1=vbuc2 
    lda #1
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B
    // stage.script_b.playbooks_b = stage_playbooks_b
    // [433] *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) = stage_playbooks_b -- _deref_qssc1=pssc2 
    lda #<stage_playbooks_b
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    lda #>stage_playbooks_b
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    // &stage_playbooks_b[stage.playbook_current]
    // [434] stage_reset::$16 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_reset__16
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_reset__16+1
    asl stage_reset__16
    rol stage_reset__16+1
    // [435] stage_reset::$17 = stage_reset::$16 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_reset__17
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_reset__17
    lda stage_reset__17+1
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_reset__17+1
    // [436] stage_reset::$9 = stage_reset::$17 << 1 -- vwum1=vwum1_rol_1 
    asl stage_reset__9
    rol stage_reset__9+1
    // [437] memcpy::source#0 = stage_playbooks_b + stage_reset::$9 -- pssz1=pssc1_plus_vwum2 
    lda stage_reset__9
    clc
    adc #<stage_playbooks_b
    sta.z memcpy.source
    lda stage_reset__9+1
    adc #>stage_playbooks_b
    sta.z memcpy.source+1
    // memcpy(&stage.current_playbook, &stage_playbooks_b[stage.playbook_current], sizeof(stage_playbook_t))
    // [438] call memcpy
    // stage.current_playbook = stage_playbook[stage.playbook];
    jsr memcpy
    // stage_reset::@3
    // stage.lives = 10
    // [439] *((char *)&stage+OFFSET_STRUCT_STAGE_T_LIVES) = $a -- _deref_pbuc1=vbuc2 
    lda #$a
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_LIVES
    // stage.scenario_total = stage.current_playbook.scenario_total_b
    // [440] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL) = *((char *)(stage_playbook_t *)&stage) -- _deref_pwuc1=_deref_pbuc2 
    lda equinoxe_stage_flight.stage
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL
    lda #0
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_TOTAL+1
    // stage_load()
    // [441] call stage_load
    // bug?
    jsr stage_load
    // stage_reset::@4
    // stage_copy(stage.ew, stage.scenario_current)
    // [442] stage_copy::ew#0 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_EW) -- vbum1=_deref_pwuc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_EW
    sta stage_copy.ew
    // [443] stage_copy::scenario#0 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT) -- vwum1=_deref_pwuc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT
    sta stage_copy.scenario
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCENARIO_CURRENT+1
    sta stage_copy.scenario+1
    // [444] call stage_copy
  // Load the artefacts of the stage.
    // [499] phi from stage_reset::@4 to stage_copy [phi:stage_reset::@4->stage_copy]
    // [499] phi stage_copy::ew#2 = stage_copy::ew#0 [phi:stage_reset::@4->stage_copy#0] -- register_copy 
    // [499] phi stage_copy::scenario#2 = stage_copy::scenario#0 [phi:stage_reset::@4->stage_copy#1] -- register_copy 
    jsr stage_copy
    // stage_reset::@5
    // stage_player_t* stage_player = stage_playbooks_b->stage_player
    // [445] stage_reset::stage_player#0 = *((stage_player_t **)stage_playbooks_b+OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER) -- pssz1=_deref_qssc1 
    // Add the player to the stage.
    lda stage_playbooks_b+OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER
    sta.z stage_player
    lda stage_playbooks_b+OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER+1
    sta.z stage_player+1
    // stage_engine_t* stage_engine = stage_player->stage_engine
    // [446] stage_reset::stage_engine#0 = ((stage_engine_t **)stage_reset::stage_player#0)[OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE
    lda (stage_player),y
    sta.z stage_engine
    iny
    lda (stage_player),y
    sta.z stage_engine+1
    // player_add(stage_player->player_sprite, stage_engine->engine_sprite)
    // [447] player_add::sprite_player#0 = *((char *)stage_reset::stage_player#0) -- vbuxx=_deref_pbuz1 
    ldy #0
    lda (stage_player),y
    tax
    // [448] player_add::sprite_engine#0 = *((char *)stage_reset::stage_engine#0) -- vbum1=_deref_pbuz2 
    lda (stage_engine),y
    sta player_add.sprite_engine
    // [449] call player_add
    // [455] phi from stage_reset::@5 to player_add [phi:stage_reset::@5->player_add]
    // [455] phi player_add::sprite_engine#2 = player_add::sprite_engine#0 [phi:stage_reset::@5->player_add#0] -- register_copy 
    // [455] phi player_add::sprite_player#2 = player_add::sprite_player#0 [phi:stage_reset::@5->player_add#1] -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <player_add
    .byte >player_add
    .byte 9
    // stage_reset::@return
    // }
    // [450] return 
    rts
  .segment DataEngineStages
    .label stage_reset__9 = stage_load.scenario
    .label stage_reset__16 = stage_load.scenario
    .label stage_reset__17 = stage_load.scenario
}
.segment Code
  // cx16_irq_relay
// void cx16_irq_relay(void (*irq)())
cx16_irq_relay: {
    .label irq = irq_vsync
    // *KERNEL_IRQ = irq
    // [451] *KERNEL_IRQ = cx16_irq_relay::irq#0 -- _deref_qprc1=pprc2 
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // cx16_irq_relay::@return
    // }
    // [452] return 
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
    // [454] return 
    rts
  .segment Data
    visible: .byte 0
    scalex: .byte 0
    scaley: .byte 0
}
.segment CodeEnginePlayers
  // player_add
// void player_add(__register(X) char sprite_player, __mem() char sprite_engine)
// __bank(cx16_ram, 9) 
player_add: {
    // unsigned char p = flight_add(FLIGHT_PLAYER, SIDE_PLAYER, sprite_player)
    // [456] flight_add::type = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_flightengine.flight_add.type
    // [457] flight_add::side = 0 -- vbum1=vbuc1 
    sta equinoxe_flightengine.flight_add.side
    // [458] flight_add::sprite = player_add::sprite_player#2 -- vbum1=vbuxx 
    stx equinoxe_flightengine.flight_add.sprite
    // [459] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [460] player_add::p#0 = flight_add::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_add.return
    sta p
    // flight.moved[p] = 2
    // [461] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_MOVED)[player_add::p#0] = 2 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #2
    ldy p
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_MOVED,y
    // flight.firegun[p] = 0
    // [462] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_FIREGUN,y
    // flight.reload[p] = 0
    // [463] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_RELOAD)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_RELOAD,y
    // flight.health[p] = 100
    // [464] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[player_add::p#0] = $64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #$64
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    // flight.impact[p] = -100
    // [465] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_IMPACT)[player_add::p#0] = -$64 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #-$64
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_IMPACT,y
    // animate_add(6,3,3,10,1,0)
    // [466] animate_add::count = 6 -- vbuz1=vbuc1 
    lda #6
    sta.z equinoxe_animate.animate_add.count
    // [467] animate_add::state = 3 -- vbuz1=vbuc1 
    lda #3
    sta.z equinoxe_animate.animate_add.state
    // [468] animate_add::loop = 3 -- vbuz1=vbuc1 
    sta.z equinoxe_animate.animate_add.loop
    // [469] animate_add::speed = $a -- vbuz1=vbuc1 
    lda #$a
    sta.z equinoxe_animate.animate_add.speed
    // [470] animate_add::direction = 1 -- vbsz1=vbsc1 
    lda #1
    sta.z equinoxe_animate.animate_add.direction
    // [471] animate_add::reverse = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_animate.animate_add.reverse
    // [472] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [473] player_add::$1 = animate_add::return -- vbuaa=vbuz1 
    lda.z equinoxe_animate.animate_add.return
    // flight.animate[p] = animate_add(6,3,3,10,1,0)
    // [474] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_add::p#0] = player_add::$1 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy p
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // flight.xf[p] = 0
    // [475] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_XF)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XF,y
    // flight.yf[p] = 0
    // [476] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_YF)[player_add::p#0] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YF,y
    // flight.xi[p] = 320
    // [477] player_add::$5 = player_add::p#0 << 1 -- vbuxx=vbum1_rol_1 
    tya
    asl
    tax
    // [478] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[player_add::$5] = $140 -- pwuc1_derefidx_vbuxx=vwuc2 
    lda #<$140
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda #>$140
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[p] = 200
    // [479] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[player_add::$5] = $c8 -- pwuc1_derefidx_vbuxx=vbuc2 
    lda #$c8
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // flight.xd[p] = 0
    // [480] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[player_add::$5] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,x
    // flight.yd[p] = 0
    // [481] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[player_add::$5] = 0 -- pwuc1_derefidx_vbuxx=vbuc2 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,x
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,x
    // unsigned char n = flight_add(FLIGHT_ENGINE, SIDE_PLAYER, sprite_engine)
    // [482] flight_add::type = 4 -- vbum1=vbuc1 
    lda #4
    sta equinoxe_flightengine.flight_add.type
    // [483] flight_add::side = 0 -- vbum1=vbuc1 
    lda #0
    sta equinoxe_flightengine.flight_add.side
    // [484] flight_add::sprite = player_add::sprite_engine#2 -- vbum1=vbum2 
    lda sprite_engine
    sta equinoxe_flightengine.flight_add.sprite
    // [485] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [486] player_add::n#0 = flight_add::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_add.return
    sta n
    // flight.engine[p] = n
    // [487] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ENGINE)[player_add::p#0] = player_add::n#0 -- pbuc1_derefidx_vbum1=vbum2 
    ldy p
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ENGINE,y
    // animate_add(16,0,0,2,1,0)
    // [488] animate_add::count = $10 -- vbuz1=vbuc1 
    lda #$10
    sta.z equinoxe_animate.animate_add.count
    // [489] animate_add::state = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_animate.animate_add.state
    // [490] animate_add::loop = 0 -- vbuz1=vbuc1 
    sta.z equinoxe_animate.animate_add.loop
    // [491] animate_add::speed = 2 -- vbuz1=vbuc1 
    lda #2
    sta.z equinoxe_animate.animate_add.speed
    // [492] animate_add::direction = 1 -- vbsz1=vbsc1 
    lda #1
    sta.z equinoxe_animate.animate_add.direction
    // [493] animate_add::reverse = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_animate.animate_add.reverse
    // [494] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [495] player_add::$3 = animate_add::return -- vbuaa=vbuz1 
    lda.z equinoxe_animate.animate_add.return
    // flight.animate[n] = animate_add(16,0,0,2,1,0)
    // [496] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[player_add::n#0] = player_add::$3 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy n
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // stage.player = p
    // [497] *((char *)&stage+OFFSET_STRUCT_STAGE_T_PLAYER) = player_add::p#0 -- _deref_pbuc1=vbum1 
    lda p
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYER
    // player_add::@return
    // }
    // [498] return 
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
    .label stage_playbook_ptr1_stage_playbooks_b = $44
    .label stage_playbook_ptr1_return = $48
    .label stage_scenario_ptr1_stage_scenarios_b = $44
    .label stage_scenario_ptr1_return = $48
    .label stage_enemy = $44
    // stage_copy::stage_playbook_ptr1
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [500] stage_copy::stage_playbook_ptr1_stage_playbooks_b#0 = *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) -- pssz1=_deref_qssc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    sta.z stage_playbook_ptr1_stage_playbooks_b
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    sta.z stage_playbook_ptr1_stage_playbooks_b+1
    // &stage_playbooks_b[stage.playbook_current]
    // [501] stage_copy::$34 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_copy__34
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_copy__34+1
    asl stage_copy__34
    rol stage_copy__34+1
    // [502] stage_copy::$35 = stage_copy::$34 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_copy__35
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_copy__35
    lda stage_copy__35+1
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_copy__35+1
    // [503] stage_copy::stage_playbook_ptr1_$1 = stage_copy::$35 << 1 -- vwum1=vwum1_rol_1 
    asl stage_playbook_ptr1_stage_copy__1
    rol stage_playbook_ptr1_stage_copy__1+1
    // [504] stage_copy::stage_playbook_ptr1_return#0 = stage_copy::stage_playbook_ptr1_stage_playbooks_b#0 + stage_copy::stage_playbook_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_playbook_ptr1_stage_copy__1
    clc
    adc.z stage_playbook_ptr1_stage_playbooks_b
    sta.z stage_playbook_ptr1_return
    lda stage_playbook_ptr1_stage_copy__1+1
    adc.z stage_playbook_ptr1_stage_playbooks_b+1
    sta.z stage_playbook_ptr1_return+1
    // stage_copy::stage_scenario_ptr1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_ptr_b->scenarios_b
    // [505] stage_copy::stage_scenario_ptr1_stage_scenarios_b#0 = ((stage_scenario_t **)stage_copy::stage_playbook_ptr1_return#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b
    iny
    lda (stage_playbook_ptr1_return),y
    sta.z stage_scenario_ptr1_stage_scenarios_b+1
    // &stage_scenarios_b[scenario]
    // [506] stage_copy::stage_scenario_ptr1_$1 = stage_copy::scenario#2 << 4 -- vwum1=vwum2_rol_4 
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
    // [507] stage_copy::stage_scenario_ptr1_return#0 = stage_copy::stage_scenario_ptr1_stage_scenarios_b#0 + stage_copy::stage_scenario_ptr1_$1 -- pssz1=pssz2_plus_vwum3 
    lda stage_scenario_ptr1_stage_copy__1
    clc
    adc.z stage_scenario_ptr1_stage_scenarios_b
    sta.z stage_scenario_ptr1_return
    lda stage_scenario_ptr1_stage_copy__1+1
    adc.z stage_scenario_ptr1_stage_scenarios_b+1
    sta.z stage_scenario_ptr1_return+1
    // stage_copy::@1
    // wave.x[ew] = stage_scenario_ptr_b->x
    // [508] stage_copy::$4 = stage_copy::ew#2 << 1 -- vbum1=vbum2_rol_1 
    lda ew
    asl
    sta stage_copy__4
    // [509] ((int *)&wave+OFFSET_STRUCT_WAVE_T_X)[stage_copy::$4] = ((int *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_X] -- pwsc1_derefidx_vbum1=pwsz2_derefidx_vbuc2 
    tax
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_X
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_X,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_X+1,x
    // wave.y[ew] = stage_scenario_ptr_b->y
    // [510] ((int *)&wave+OFFSET_STRUCT_WAVE_T_Y)[stage_copy::$4] = ((int *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_Y] -- pwsc1_derefidx_vbum1=pwsz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_Y
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_Y,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_Y+1,x
    // wave.enemy_count[ew] = stage_scenario_ptr_b->enemy_count
    // [511] ((char *)&wave)[stage_copy::ew#2] = *((char *)stage_copy::stage_scenario_ptr1_return#0) -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_scenario_ptr1_return),y
    ldy ew
    sta equinoxe_waves.wave,y
    // wave.dx[ew] = stage_scenario_ptr_b->dx
    // [512] ((signed char *)&wave+OFFSET_STRUCT_WAVE_T_DX)[stage_copy::ew#2] = ((signed char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_DX] -- pbsc1_derefidx_vbum1=pbsz2_derefidx_vbuc2 
    ldx ew
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_DX
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_DX,x
    // wave.dy[ew] = stage_scenario_ptr_b->dy
    // [513] ((signed char *)&wave+OFFSET_STRUCT_WAVE_T_DY)[stage_copy::ew#2] = ((signed char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_DY] -- pbsc1_derefidx_vbum1=pbsz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_DY
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_DY,x
    // wave.enemy_flightpath[ew] = stage_scenario_ptr_b->enemy_flightpath
    // [514] ((stage_flightpath_t **)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_FLIGHTPATH)[stage_copy::$4] = ((stage_flightpath_t **)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_FLIGHTPATH] -- qssc1_derefidx_vbum1=qssz2_derefidx_vbuc2 
    ldx stage_copy__4
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_FLIGHTPATH
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_FLIGHTPATH,x
    iny
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_FLIGHTPATH+1,x
    // wave.enemy_spawn[ew] = stage_scenario_ptr_b->enemy_spawn
    // [515] ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_SPAWN] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldx ew
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_ENEMY_SPAWN
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPAWN,x
    // stage_enemy_t* stage_enemy = stage_scenario_ptr_b->stage_enemy
    // [516] stage_copy::stage_enemy#0 = ((stage_enemy_t **)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY
    lda (stage_scenario_ptr1_return),y
    sta.z stage_enemy
    iny
    lda (stage_scenario_ptr1_return),y
    sta.z stage_enemy+1
    // wave.animation_speed[ew] = stage_enemy->animation_speed
    // [517] ((char *)&wave+OFFSET_STRUCT_WAVE_T_ANIMATION_SPEED)[stage_copy::ew#2] = ((char *)stage_copy::stage_enemy#0)[OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_SPEED] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_SPEED
    lda (stage_enemy),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ANIMATION_SPEED,x
    // wave.animation_reverse[ew] = stage_enemy->animation_reverse
    // [518] ((char *)&wave+OFFSET_STRUCT_WAVE_T_ANIMATION_REVERSE)[stage_copy::ew#2] = ((char *)stage_copy::stage_enemy#0)[OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_REVERSE] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_ENEMY_T_ANIMATION_REVERSE
    lda (stage_enemy),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ANIMATION_REVERSE,x
    // wave.enemy_sprite[ew] = stage_enemy->enemy_sprite_flight
    // [519] ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPRITE)[stage_copy::ew#2] = *((char *)stage_copy::stage_enemy#0) -- pbuc1_derefidx_vbum1=_deref_pbuz2 
    ldy #0
    lda (stage_enemy),y
    ldy ew
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_SPRITE,y
    // wave.interval[ew] = stage_scenario_ptr_b->interval
    // [520] ((char *)&wave+OFFSET_STRUCT_WAVE_T_INTERVAL)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_INTERVAL] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_INTERVAL
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_INTERVAL,x
    // wave.prev[ew] = stage_scenario_ptr_b->prev
    // [521] ((char *)&wave+OFFSET_STRUCT_WAVE_T_PREV)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_PREV] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_PREV
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_PREV,x
    // wave.wait[ew] = stage_scenario_ptr_b->wait
    // [522] ((char *)&wave+OFFSET_STRUCT_WAVE_T_WAIT)[stage_copy::ew#2] = ((char *)stage_copy::stage_scenario_ptr1_return#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_WAIT] -- pbuc1_derefidx_vbum1=pbuz2_derefidx_vbuc2 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_WAIT
    lda (stage_scenario_ptr1_return),y
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_WAIT,x
    // wave.used[ew] = 1
    // [523] ((char *)&wave+OFFSET_STRUCT_WAVE_T_USED)[stage_copy::ew#2] = 1 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #1
    ldy ew
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_USED,y
    // wave.finished[ew] = 0
    // [524] ((char *)&wave+OFFSET_STRUCT_WAVE_T_FINISHED)[stage_copy::ew#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_FINISHED,y
    // wave.scenario[ew] = scenario
    // [525] ((unsigned int *)&wave+OFFSET_STRUCT_WAVE_T_SCENARIO)[stage_copy::$4] = stage_copy::scenario#2 -- pwuc1_derefidx_vbum1=vwum2 
    ldy stage_copy__4
    lda scenario
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_SCENARIO,y
    lda scenario+1
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_SCENARIO+1,y
    // wave.enemy_alive[ew] = 0
    // [526] ((char *)&wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE)[stage_copy::ew#2] = 0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #0
    ldy ew
    sta equinoxe_waves.wave+OFFSET_STRUCT_WAVE_T_ENEMY_ALIVE,y
    // stage_copy::@return
    // }
    // [527] return 
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
    // [528] enemy_add::w = stage_enemy_add::w#0 -- vbum1=vbum2 
    lda w
    sta equinoxe_enemy.enemy_add.w
    // [529] enemy_add::sprite_enemy = stage_enemy_add::enemy_sprite#0 -- vbum1=vbuxx 
    stx equinoxe_enemy.enemy_add.sprite_enemy
    // [530] callexecute enemy_add  -- call_var_far_cx16_ram 
    jsr $ff6e
    .byte <equinoxe_enemy.enemy_add
    .byte >equinoxe_enemy.enemy_add
    .byte 8
    // wave_set(w)
    // [531] wave_set::w = stage_enemy_add::w#0 -- vbum1=vbum2 
    lda w
    sta equinoxe_waves.wave_set.w
    // [532] callexecute wave_set  -- call_var_near 
    jsr equinoxe_waves.wave_set
    // stage.enemy_count++;
    // [533] *((char *)&stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT) = ++ *((char *)&stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_ENEMY_COUNT
    // stage_enemy_add::@return
    // }
    // [534] return 
    rts
  .segment Data
    .label w = player_add.sprite_engine
}
.segment CodeEngineStages
  // stage_bullet_add
// void stage_bullet_add(__mem() unsigned int sx, __mem() unsigned int sy, __mem() unsigned int tx, unsigned int ty, char speed, char side, char sprite_bullet)
// __bank(cx16_ram, 3) 
stage_bullet_add: {
    .label speed = 5
    .label side = 0
    .label sprite_bullet = $11
    // bullet_add(sx, sy, tx, ty, speed, side, sprite_bullet)
    // [535] bullet_add::sx#0 = stage_bullet_add::sx#0
    // [536] bullet_add::sy#0 = stage_bullet_add::sy#0
    // [537] bullet_add::tx#0 = stage_bullet_add::tx#0
    // [538] call bullet_add -- call_phi_far_cx16_ram 
    jsr $ff6e
    .byte <bullet_add
    .byte >bullet_add
    .byte 7
    // stage_bullet_add::@1
    // stage.bullet_count++;
    // [539] *((char *)&stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT) = ++ *((char *)&stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT) -- _deref_pbuc1=_inc__deref_pbuc1 
    inc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_BULLET_COUNT
    // stage_bullet_add::@return
    // }
    // [540] return 
    rts
  .segment Data
    sx: .word 0
    sy: .word 0
    tx: .word 0
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
// unsigned int fload_bram(__zp($4a) char *filename, __register(X) char dbank, char *dptr)
fload_bram: {
    .label fp = $4c
    .label filename = $4a
    // fload_bram::bank_get_bram1
    // return BRAM;
    // [542] fload_bram::bank_set_bram2_bank#0 = BRAM -- vbum1=vbuz2 
    lda.z BRAM
    sta bank_set_bram2_bank
    // fload_bram::bank_set_bram1
    // BRAM = bank
    // [543] BRAM = fload_bram::dbank#10 -- vbuz1=vbuxx 
    stx.z BRAM
    // fload_bram::@4
    // FILE* fp = fopen(filename,"r")
    // [544] fopen::path = fload_bram::filename#10 -- pbuz1=pbuz2 
    lda.z filename
    sta.z lib_file.fopen.path
    lda.z filename+1
    sta.z lib_file.fopen.path+1
    // [545] fopen::mode = fload_bram::mode -- pbuz1=pbuc1 
    lda #<mode
    sta.z lib_file.fopen.mode
    lda #>mode
    sta.z lib_file.fopen.mode+1
    // [546] callexecute fopen  -- call_var_near 
    jsr lib_file.fopen
    // [547] fload_bram::fp#0 = fopen::return -- pssz1=pssz2 
    lda.z lib_file.fopen.return
    sta.z fp
    lda.z lib_file.fopen.return+1
    sta.z fp+1
    // if(fp)
    // [548] if((struct file_handle_s *)0==fload_bram::fp#0) goto fload_bram::bank_set_bram2 -- pssc1_eq_pssz1_then_la1 
    lda.z fp
    cmp #<0
    bne !+
    lda.z fp+1
    cmp #>0
    beq bank_set_bram2
  !:
    // fload_bram::@1
    // fgets(dptr, 0, fp)
    // [549] fgets::ptr = (char *) 40960 -- pbuz1=pbuc1 
    lda #<$a000
    sta.z lib_file.fgets.ptr
    lda #>$a000
    sta.z lib_file.fgets.ptr+1
    // [550] fgets::size = 0 -- vwum1=vbuc1 
    lda #<0
    sta lib_file.fgets.size
    sta lib_file.fgets.size+1
    // [551] fgets::stream = fload_bram::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fgets.stream
    lda.z fp+1
    sta.z lib_file.fgets.stream+1
    // [552] callexecute fgets  -- call_var_near 
    jsr lib_file.fgets
    // read = fgets(dptr, 0, fp)
    // [553] fload_bram::read#1 = fgets::return -- vwum1=vwum2 
    lda lib_file.fgets.return
    sta read
    lda lib_file.fgets.return+1
    sta read+1
    // if(read)
    // [554] if(0!=fload_bram::read#1) goto fload_bram::@3 -- 0_neq_vwum1_then_la1 
    lda read
    ora read+1
    bne __b3
    // fload_bram::@2
    // fclose(fp)
    // [555] fclose::stream = fload_bram::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fclose.stream
    lda.z fp+1
    sta.z lib_file.fclose.stream+1
    // [556] callexecute fclose  -- call_var_near 
    jsr lib_file.fclose
    // fload_bram::bank_set_bram2
  bank_set_bram2:
    // BRAM = bank
    // [557] BRAM = fload_bram::bank_set_bram2_bank#0 -- vbuz1=vbum2 
    lda bank_set_bram2_bank
    sta.z BRAM
    // fload_bram::@return
    // }
    // [558] return 
    rts
    // fload_bram::@3
  __b3:
    // fclose(fp)
    // [559] fclose::stream = fload_bram::fp#0 -- pssz1=pssz2 
    lda.z fp
    sta.z lib_file.fclose.stream
    lda.z fp+1
    sta.z lib_file.fclose.stream+1
    // [560] callexecute fclose  -- call_var_near 
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
    .label end = equinoxe_stage_flight.stage+SIZEOF_STRUCT_STAGE_T
    .label dst = $4a
    // [562] phi from memset to memset::@1 [phi:memset->memset::@1]
    // [562] phi memset::dst#2 = (char *)(void *)&stage [phi:memset->memset::@1#0] -- pbuz1=pbuc1 
    lda #<equinoxe_stage_flight.stage
    sta.z dst
    lda #>equinoxe_stage_flight.stage
    sta.z dst+1
    // memset::@1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    // [563] if(memset::dst#2!=memset::end#0) goto memset::@2 -- pbuz1_neq_pbuc1_then_la1 
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // memset::@return
    // }
    // [564] return 
    rts
    // memset::@2
  __b2:
    // *dst = c
    // [565] *memset::dst#2 = 0 -- _deref_pbuz1=vbuc1 
    lda #0
    tay
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    // [566] memset::dst#1 = ++ memset::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [562] phi from memset::@2 to memset::@1 [phi:memset::@2->memset::@1]
    // [562] phi memset::dst#2 = memset::dst#1 [phi:memset::@2->memset::@1#0] -- register_copy 
    jmp __b1
}
  // memcpy
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// void * memcpy(void *destination, __zp($4c) volatile stage_playbook_t *source, unsigned int num)
memcpy: {
    .label destination = equinoxe_stage_flight.stage
    .label src_end = $50
    .label dst = $4a
    .label src = $4c
    .label source = $4c
    // char* src_end = (char*)source+num
    // [567] memcpy::src_end#0 = (char *)(void *)memcpy::source#0 + SIZEOF_STRUCT_STAGE_PLAYBOOK_T -- pbuz1=pbuz2_plus_vbuc1 
    lda #SIZEOF_STRUCT_STAGE_PLAYBOOK_T
    clc
    adc.z source
    sta.z src_end
    lda #0
    adc.z source+1
    sta.z src_end+1
    // [568] memcpy::src#4 = (char *)(void *)memcpy::source#0
    // [569] phi from memcpy to memcpy::@1 [phi:memcpy->memcpy::@1]
    // [569] phi memcpy::dst#2 = (char *)memcpy::destination#0 [phi:memcpy->memcpy::@1#0] -- pbuz1=pbuc1 
    lda #<destination
    sta.z dst
    lda #>destination
    sta.z dst+1
    // [569] phi memcpy::src#2 = memcpy::src#4 [phi:memcpy->memcpy::@1#1] -- register_copy 
    // memcpy::@1
  __b1:
    // while(src!=src_end)
    // [570] if(memcpy::src#2!=memcpy::src_end#0) goto memcpy::@2 -- pbuz1_neq_pbuz2_then_la1 
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    // memcpy::@return
    // }
    // [571] return 
    rts
    // memcpy::@2
  __b2:
    // *dst++ = *src++
    // [572] *memcpy::dst#2 = *memcpy::src#2 -- _deref_pbuz1=_deref_pbuz2 
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
    // [573] memcpy::dst#1 = ++ memcpy::dst#2 -- pbuz1=_inc_pbuz1 
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    // [574] memcpy::src#1 = ++ memcpy::src#2 -- pbuz1=_inc_pbuz1 
    inc.z src
    bne !+
    inc.z src+1
  !:
    // [569] phi from memcpy::@2 to memcpy::@1 [phi:memcpy::@2->memcpy::@1]
    // [569] phi memcpy::dst#2 = memcpy::dst#1 [phi:memcpy::@2->memcpy::@1#0] -- register_copy 
    // [569] phi memcpy::src#2 = memcpy::src#1 [phi:memcpy::@2->memcpy::@1#1] -- register_copy 
    jmp __b1
}
.segment CodeEngineStages
  // stage_load
// void stage_load()
// __bank(cx16_ram, 3) 
stage_load: {
    .label stage_playbooks_b = $46
    .label stage_playbook_b = $46
    .label stage_scenarios_b = $52
    .label stage_scenario = $46
    // stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b
    // [575] stage_load::stage_playbooks_b#0 = *((stage_playbook_t **)(stage_script_t *)&stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B) -- pssz1=_deref_qssc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B
    sta.z stage_playbooks_b
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SCRIPT_B+OFFSET_STRUCT_STAGE_SCRIPT_T_PLAYBOOKS_B+1
    sta.z stage_playbooks_b+1
    // stage_playbook_t* stage_playbook_b = &stage_playbooks_b[stage.playbook_current]
    // [576] stage_load::$15 = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) << 2 -- vwum1=_deref_pwuc1_rol_2 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    asl
    sta stage_load__15
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    rol
    sta stage_load__15+1
    asl stage_load__15
    rol stage_load__15+1
    // [577] stage_load::$16 = stage_load::$15 + *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT) -- vwum1=vwum1_plus__deref_pwuc1 
    clc
    lda stage_load__16
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT
    sta stage_load__16
    lda stage_load__16+1
    adc equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_PLAYBOOK_CURRENT+1
    sta stage_load__16+1
    // [578] stage_load::$5 = stage_load::$16 << 1 -- vwum1=vwum1_rol_1 
    asl stage_load__5
    rol stage_load__5+1
    // [579] stage_load::stage_playbook_b#0 = stage_load::stage_playbooks_b#0 + stage_load::$5 -- pssz1=pssz1_plus_vwum2 
    clc
    lda.z stage_playbook_b
    adc stage_load__5
    sta.z stage_playbook_b
    lda.z stage_playbook_b+1
    adc stage_load__5+1
    sta.z stage_playbook_b+1
    // stage_scenario_t* stage_scenarios_b = stage_playbook_b->scenarios_b
    // [580] stage_load::stage_scenarios_b#0 = ((stage_scenario_t **)stage_load::stage_playbook_b#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_SCENARIOS_B
    lda (stage_playbook_b),y
    sta.z stage_scenarios_b
    iny
    lda (stage_playbook_b),y
    sta.z stage_scenarios_b+1
    // unsigned int stage_scenario_total = stage_playbook_b->scenario_total_b
    // [581] stage_load::stage_scenario_total#0 = (unsigned int)*((char *)stage_load::stage_playbook_b#0) -- vwum1=_word__deref_pbuz2 
    ldy #0
    lda (stage_playbook_b),y
    sta stage_scenario_total
    tya
    sta stage_scenario_total+1
    // stage_load_player(stage_playbook_b->stage_player)
    // [582] stage_load_player::stage_player#0 = ((stage_player_t **)stage_load::stage_playbook_b#0)[OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYBOOK_T_STAGE_PLAYER
    lda (stage_playbook_b),y
    sta.z stage_load_player.stage_player
    iny
    lda (stage_playbook_b),y
    sta.z stage_load_player.stage_player+1
    // [583] call stage_load_player
    jsr stage_load_player
    // [584] phi from stage_load to stage_load::@1 [phi:stage_load->stage_load::@1]
    // [584] phi stage_load::scenario#2 = 0 [phi:stage_load->stage_load::@1#0] -- vwum1=vwuc1 
    lda #<0
    sta scenario
    sta scenario+1
  // Loading the enemy sprites in bram.
    // stage_load::@1
  __b1:
    // for(unsigned int scenario = 0; scenario < stage_scenario_total; scenario++)
    // [585] if(stage_load::scenario#2<stage_load::stage_scenario_total#0) goto stage_load::@2 -- vwum1_lt_vwum2_then_la1 
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
    // [586] return 
    rts
    // stage_load::@2
  __b2:
    // stage_scenario_t* stage_scenario = &stage_scenarios_b[scenario]
    // [587] stage_load::$6 = stage_load::scenario#2 << 4 -- vwum1=vwum2_rol_4 
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
    // [588] stage_load::stage_scenario#0 = stage_load::stage_scenarios_b#0 + stage_load::$6 -- pssz1=pssz2_plus_vwum3 
    lda stage_load__6
    clc
    adc.z stage_scenarios_b
    sta.z stage_scenario
    lda stage_load__6+1
    adc.z stage_scenarios_b+1
    sta.z stage_scenario+1
    // stage_load_enemy(stage_scenario->stage_enemy)
    // [589] stage_load_enemy::stage_enemy#0 = ((stage_enemy_t **)stage_load::stage_scenario#0)[OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_SCENARIO_T_STAGE_ENEMY
    lda (stage_scenario),y
    sta.z stage_load_enemy.stage_enemy
    iny
    lda (stage_scenario),y
    sta.z stage_load_enemy.stage_enemy+1
    // [590] call stage_load_enemy
    jsr stage_load_enemy
    // stage_load::@3
    // for(unsigned int scenario = 0; scenario < stage_scenario_total; scenario++)
    // [591] stage_load::scenario#1 = ++ stage_load::scenario#2 -- vwum1=_inc_vwum1 
    inc scenario
    bne !+
    inc scenario+1
  !:
    // [584] phi from stage_load::@3 to stage_load::@1 [phi:stage_load::@3->stage_load::@1]
    // [584] phi stage_load::scenario#2 = stage_load::scenario#1 [phi:stage_load::@3->stage_load::@1#0] -- register_copy 
    jmp __b1
  .segment DataEngineStages
    .label stage_load__5 = scenario
    stage_load__6: .word 0
    stage_scenario_total: .word 0
    scenario: .word 0
    .label stage_load__15 = scenario
    .label stage_load__16 = scenario
}
.segment CodeEngineBullets
  // bullet_add
// char bullet_add(__mem() unsigned int sx, __mem() unsigned int sy, __mem() unsigned int tx, unsigned int ty, char speed, char side, char sprite_bullet)
// __bank(cx16_ram, 7) 
bullet_add: {
    .const aty = 0
    .label math_vecy1_return = $4e
    // flight_index_t b = flight_add(FLIGHT_BULLET, side, sprite_bullet)
    // [592] flight_add::type = 3 -- vbum1=vbuc1 
    lda #3
    sta equinoxe_flightengine.flight_add.type
    // [593] flight_add::side = stage_bullet_add::side#0 -- vbum1=vbuc1 
    lda #stage_bullet_add.side
    sta equinoxe_flightengine.flight_add.side
    // [594] flight_add::sprite = stage_bullet_add::sprite_bullet#0 -- vbum1=vbuc1 
    lda #stage_bullet_add.sprite_bullet
    sta equinoxe_flightengine.flight_add.sprite
    // [595] callexecute flight_add  -- call_var_near 
    jsr equinoxe_flightengine.flight_add
    // [596] bullet_add::b#0 = flight_add::return -- vbum1=vbum2 
    lda equinoxe_flightengine.flight_add.return
    sta b
    // sx >> 2
    // [597] bullet_add::$1 = bullet_add::sx#0 >> 2 -- vwum1=vwum2_ror_2 
    lda sx+1
    lsr
    sta bullet_add__1+1
    lda sx
    ror
    sta bullet_add__1
    lsr bullet_add__1+1
    ror bullet_add__1
    // unsigned char asx = BYTE0(sx >> 2)
    // [598] bullet_add::asx#0 = byte0  bullet_add::$1 -- vbuyy=_byte0_vwum1 
    ldy bullet_add__1
    // sy >> 2
    // [599] bullet_add::$3 = bullet_add::sy#0 >> 2 -- vwum1=vwum2_ror_2 
    lda sy+1
    lsr
    sta bullet_add__3+1
    lda sy
    ror
    sta bullet_add__3
    lsr bullet_add__3+1
    ror bullet_add__3
    // unsigned char asy = BYTE0(sy >> 2)
    // [600] bullet_add::asy#0 = byte0  bullet_add::$3 -- vbum1=_byte0_vwum2 
    lda bullet_add__3
    sta asy
    // tx >> 2
    // [601] bullet_add::$5 = bullet_add::tx#0 >> 2 -- vwum1=vwum2_ror_2 
    lda tx+1
    lsr
    sta bullet_add__5+1
    lda tx
    ror
    sta bullet_add__5
    lsr bullet_add__5+1
    ror bullet_add__5
    // unsigned char atx = BYTE0(tx >> 2)
    // [602] bullet_add::atx#0 = byte0  bullet_add::$5 -- vbuxx=_byte0_vwum1 
    ldx bullet_add__5
    // unsigned char angle = math_atan2(asx, atx, asy, aty)
    // [603] bullet_add::math_atan21_x1 = bullet_add::asx#0 -- vbum1=vbuyy 
    sty math_atan21_x1
    // [604] bullet_add::math_atan21_x2 = bullet_add::atx#0 -- vbum1=vbuxx 
    stx math_atan21_x2
    // [605] bullet_add::math_atan21_y1 = bullet_add::asy#0 -- vbum1=vbum2 
    lda asy
    sta math_atan21_y1
    // [606] bullet_add::math_atan21_y2 = bullet_add::aty#0 -- vbum1=vbuc1 
    lda #aty
    sta math_atan21_y2
    // bullet_add::math_atan21
    // unsigned char octant_temp
    // [607] bullet_add::math_atan21_octant_temp = 0 -- vbum1=vbuc1 
    lda #0
    sta math_atan21_octant_temp
    // unsigned char angle
    // [608] bullet_add::math_atan21_angle = 0 -- vbum1=vbuc1 
    sta math_atan21_angle
    // asm
    // asm { lday2 sbcy1 bcs!+ eor#$ff !: tax roloctant_temp ldax1 sbcx2 bcs!+ eor#$ff !: tay roloctant_temp ldalogtab,x sbclogtab,y bcc!+ eor#$ff !: tax ldaoctant_temp rol and#%111 tay ldaatantab,x eoradjust_octant,y staangle  }
    lda math_atan21_y2
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
    // [610] bullet_add::math_atan21_return#0 = bullet_add::math_atan21_angle -- vbuaa=vbum1 
    // bullet_add::math_atan21_@return
    // }
    // [611] bullet_add::math_atan21_return#1 = bullet_add::math_atan21_return#0
    // bullet_add::@1
    // unsigned char angle = math_atan2(asx, atx, asy, aty)
    // [612] bullet_add::angle#0 = bullet_add::math_atan21_return#1
    // signed int dx = math_vecx(angle-16, speed)
    // [613] bullet_add::math_vecy1_angle#0 = bullet_add::angle#0 - $10 -- vbuaa=vbuaa_minus_vbuc1 
    sec
    sbc #$10
    // [614] phi from bullet_add::@1 to bullet_add::math_vecx1 [phi:bullet_add::@1->bullet_add::math_vecx1]
    // bullet_add::math_vecx1
    // bullet_add::math_vecx1_@2
    // angle % 64
    // [615] bullet_add::math_vecy1_$1 = bullet_add::math_vecy1_angle#0 & $40-1 -- vbuaa=vbuaa_band_vbuc1 
    and #$40-1
    // dx = math_cos[angle % 64]
    // [616] bullet_add::math_vecy1_$2 = bullet_add::math_vecy1_$1 << 1 -- vbuxx=vbuaa_rol_1 
    asl
    tax
    // [617] bullet_add::math_vecx1_dx#1 = math_cos[bullet_add::math_vecy1_$2] -- vwsm1=pwsc1_derefidx_vbuxx 
    lda math_cos,x
    sta math_vecx1_dx
    lda math_cos+1,x
    sta math_vecx1_dx+1
    // dx <<= speed
    // [618] bullet_add::dx#1 = bullet_add::math_vecx1_dx#1 << stage_bullet_add::speed#0 -- vwsm1=vwsm2_rol_vbuc1 
    ldy #stage_bullet_add.speed
    lda math_vecx1_dx
    sta dx
    lda math_vecx1_dx+1
    sta dx+1
    cpy #0
    beq !e+
  !:
    asl dx
    rol dx+1
    dey
    bne !-
  !e:
    // [619] phi from bullet_add::math_vecx1_@2 to bullet_add::math_vecy1 [phi:bullet_add::math_vecx1_@2->bullet_add::math_vecy1]
    // bullet_add::math_vecy1
    // bullet_add::math_vecy1_@2
    // dy = math_sin[angle % 64]
    // [620] bullet_add::math_vecy1_dy#1 = math_sin[bullet_add::math_vecy1_$2] -- vwsm1=pwsc1_derefidx_vbuxx 
    lda math_sin,x
    sta math_vecy1_dy
    lda math_sin+1,x
    sta math_vecy1_dy+1
    // dy <<= speed
    // [621] bullet_add::math_vecy1_return#0 = bullet_add::math_vecy1_dy#1 << stage_bullet_add::speed#0 -- vwsz1=vwsm2_rol_vbuc1 
    ldy #stage_bullet_add.speed
    lda math_vecy1_dy
    sta.z math_vecy1_return
    lda math_vecy1_dy+1
    sta.z math_vecy1_return+1
    cpy #0
    beq !e+
  !:
    asl.z math_vecy1_return
    rol.z math_vecy1_return+1
    dey
    bne !-
  !e:
    // bullet_add::@2
    // flight.xd[b] = (unsigned int)dx
    // [622] bullet_add::$20 = bullet_add::b#0 << 1 -- vbuxx=vbum1_rol_1 
    lda b
    asl
    tax
    // [623] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XD)[bullet_add::$20] = (unsigned int)bullet_add::dx#1 -- pwuc1_derefidx_vbuxx=vwum1 
    lda dx
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD,x
    lda dx+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XD+1,x
    // flight.yd[b] = (unsigned int)dy
    // [624] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YD)[bullet_add::$20] = (unsigned int)bullet_add::math_vecy1_return#0 -- pwuc1_derefidx_vbuxx=vwuz1 
    lda.z math_vecy1_return
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD,x
    lda.z math_vecy1_return+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YD+1,x
    // flight.xi[b] = sx
    // [625] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[bullet_add::$20] = bullet_add::sx#0 -- pwuc1_derefidx_vbuxx=vwum1 
    lda sx
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,x
    lda sx+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,x
    // flight.yi[b] = sy
    // [626] ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[bullet_add::$20] = bullet_add::sy#0 -- pwuc1_derefidx_vbuxx=vwum1 
    lda sy
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    lda sy+1
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    // flight.speed[b] = speed
    // [627] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SPEED)[bullet_add::b#0] = stage_bullet_add::speed#0 -- pbuc1_derefidx_vbum1=vbuc2 
    lda #stage_bullet_add.speed
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
    // [628] animate_add::count = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT)[((char *)&flight)[bullet_add::b#0]] -- vbuz1=pbuc1_derefidx_(pbuc2_derefidx_vbum2) 
    ldx b
    ldy equinoxe_flightengine.flight,x
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_COUNT,y
    stx.z equinoxe_animate.animate_add.count
    // [629] animate_add::state = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z equinoxe_animate.animate_add.state
    // [630] animate_add::loop = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP)[((char *)&flight)[bullet_add::b#0]] -- vbuz1=pbuc1_derefidx_(pbuc2_derefidx_vbum2) 
    ldx b
    ldy equinoxe_flightengine.flight,x
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_LOOP,y
    stx.z equinoxe_animate.animate_add.loop
    // [631] animate_add::speed = 1 -- vbuz1=vbuc1 
    lda #1
    sta.z equinoxe_animate.animate_add.speed
    // [632] animate_add::direction = 1 -- vbsz1=vbsc1 
    sta.z equinoxe_animate.animate_add.direction
    // [633] animate_add::reverse = ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE)[((char *)&flight)[bullet_add::b#0]] -- vbuz1=pbuc1_derefidx_(pbuc2_derefidx_vbum2) 
    ldx b
    ldy equinoxe_flightengine.flight,x
    ldx equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_REVERSE,y
    stx.z equinoxe_animate.animate_add.reverse
    // [634] callexecute animate_add  -- call_var_near 
    jsr equinoxe_animate.animate_add
    // [635] bullet_add::$14 = animate_add::return -- vbuaa=vbuz1 
    lda.z equinoxe_animate.animate_add.return
    // flight.animate[b] = animate_add(
    //         sprite_cache.count[flight.cache[b]], 
    //         0, 
    //         sprite_cache.loop[flight.cache[b]], 
    //         1, 
    //         1, 
    //         sprite_cache.reverse[flight.cache[b]]
    //         )
    // [636] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE)[bullet_add::b#0] = bullet_add::$14 -- pbuc1_derefidx_vbum1=vbuaa 
    ldy b
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_ANIMATE,y
    // rand()
    // [637] call rand
    jsr rand
    // [638] rand::return#2 = rand::return#0
    // bullet_add::@3
    // [639] bullet_add::$15 = rand::return#2 -- vwum1=vwum2 
    lda rand.return
    sta bullet_add__15
    lda rand.return+1
    sta bullet_add__15+1
    // BYTE0(rand())
    // [640] bullet_add::$16 = byte0  bullet_add::$15 -- vbuaa=_byte0_vwum1 
    lda bullet_add__15
    // BYTE0(rand())>>4
    // [641] bullet_add::impact#0 = bullet_add::$16 >> 4 -- vbuxx=vbuaa_ror_4 
    lsr
    lsr
    lsr
    lsr
    tax
    // flight.health[b] = 0
    // [642] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_HEALTH)[bullet_add::b#0] = 0 -- pbsc1_derefidx_vbum1=vbsc2 
    lda #0
    ldy b
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_HEALTH,y
    // -impact
    // [643] bullet_add::$18 = - (signed char)bullet_add::impact#0 -- vbsaa=_neg_vbsxx 
    txa
    eor #$ff
    clc
    adc #1
    // flight.impact[b] = -impact
    // [644] ((signed char *)&flight+OFFSET_STRUCT_FLIGHT_T_IMPACT)[bullet_add::b#0] = bullet_add::$18 -- pbsc1_derefidx_vbum1=vbsaa 
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_IMPACT,y
    // bullet_add::@return
    // }
    // [645] return 
    rts
  .segment DataEngineBullets
    .label bullet_add__1 = bullet_logic.x
    .label bullet_add__3 = bullet_logic.x
    .label bullet_add__5 = bullet_logic.x
    .label bullet_add__15 = bullet_logic.x
  .segment Data
    math_atan21_x1: .byte 0
    math_atan21_x2: .byte 0
    math_atan21_y1: .byte 0
    math_atan21_y2: .byte 0
    math_atan21_octant_temp: .byte 0
    math_atan21_angle: .byte 0
  .segment DataEngineBullets
    .label b = bullet_logic.b
    .label asy = bullet_logic.b_1
  .segment Data
    .label math_vecx1_dx = stage_bullet_add.tx
    .label math_vecy1_dy = stage_bullet_add.tx
    .label sx = stage_bullet_add.sx
    .label sy = stage_bullet_add.sy
    .label tx = stage_bullet_add.tx
  .segment DataEngineBullets
    .label dx = bullet_logic.x
}
.segment CodeEngineStages
  // stage_load_player
// void stage_load_player(__zp($4a) stage_player_t *stage_player)
// __bank(cx16_ram, 3) 
stage_load_player: {
    .label stage_engine = $46
    .label stage_bullet = $46
    .label stage_player = $4a
    // sprite_index_t player_sprite = stage_player->player_sprite
    // [646] stage_load_player::player_sprite#0 = *((char *)stage_load_player::stage_player#0) -- vbuaa=_deref_pbuz1 
    // Loading the player sprites in bram.
    ldy #0
    lda (stage_player),y
    // fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [647] fe_sprite_bram_load::sprite_index = stage_load_player::player_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [648] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [649] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [650] stage_load_player::$0 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_player__0
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_player__0+1
    // stage.sprite_offset = fe_sprite_bram_load(player_sprite, stage.sprite_offset)
    // [651] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_player::$0 -- _deref_pwuc1=vwum1 
    lda stage_load_player__0
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_player__0+1
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_engine_t* stage_engine = stage_player->stage_engine
    // [652] stage_load_player::stage_engine#0 = ((stage_engine_t **)stage_load_player::stage_player#0)[OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE] -- pssz1=qssz2_derefidx_vbuc1 
    // gotoxy(0,0);
    // printf("player_sprite = %u", player_sprite);
    ldy #OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_ENGINE
    lda (stage_player),y
    sta.z stage_engine
    iny
    lda (stage_player),y
    sta.z stage_engine+1
    // sprite_index_t engine_sprite = stage_engine->engine_sprite
    // [653] stage_load_player::engine_sprite#0 = *((char *)stage_load_player::stage_engine#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_engine),y
    // fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [654] fe_sprite_bram_load::sprite_index = stage_load_player::engine_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [655] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [656] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [657] stage_load_player::$1 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_player__1
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_player__1+1
    // stage.sprite_offset = fe_sprite_bram_load(engine_sprite, stage.sprite_offset)
    // [658] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_player::$1 -- _deref_pwuc1=vwum1 
    lda stage_load_player__1
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_player__1+1
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_bullet_t* stage_bullet = stage_player->stage_bullet
    // [659] stage_load_player::stage_bullet#0 = ((stage_bullet_t **)stage_load_player::stage_player#0)[OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_PLAYER_T_STAGE_BULLET
    lda (stage_player),y
    sta.z stage_bullet
    iny
    lda (stage_player),y
    sta.z stage_bullet+1
    // sprite_index_t bullet_sprite = stage_bullet->bullet_sprite
    // [660] stage_load_player::bullet_sprite#0 = *((char *)stage_load_player::stage_bullet#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_bullet),y
    // fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [661] fe_sprite_bram_load::sprite_index = stage_load_player::bullet_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [662] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [663] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [664] stage_load_player::$2 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_player__2
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_player__2+1
    // stage.sprite_offset = fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [665] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_player::$2 -- _deref_pwuc1=vwum1 
    lda stage_load_player__2
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_player__2+1
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_load_player::@return
    // }
    // [666] return 
    rts
  .segment DataEngineStages
    .label stage_load_player__0 = stage_load.scenario
    .label stage_load_player__1 = stage_load.scenario
    .label stage_load_player__2 = stage_load.scenario
}
.segment CodeEngineStages
  // stage_load_enemy
// void stage_load_enemy(__zp($50) stage_enemy_t *stage_enemy)
// __bank(cx16_ram, 3) 
stage_load_enemy: {
    .label stage_bullet = $46
    .label stage_enemy = $50
    // sprite_index_t enemy_sprite = stage_enemy->enemy_sprite_flight
    // [667] stage_load_enemy::enemy_sprite#0 = *((char *)stage_load_enemy::stage_enemy#0) -- vbuaa=_deref_pbuz1 
    // Loading the enemy sprites in bram.
    ldy #0
    lda (stage_enemy),y
    // fe_sprite_bram_load(enemy_sprite, stage.sprite_offset)
    // [668] fe_sprite_bram_load::sprite_index = stage_load_enemy::enemy_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [669] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [670] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [671] stage_load_enemy::$0 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_enemy__0
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_enemy__0+1
    // stage.sprite_offset = fe_sprite_bram_load(enemy_sprite, stage.sprite_offset)
    // [672] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_enemy::$0 -- _deref_pwuc1=vwum1 
    lda stage_load_enemy__0
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_enemy__0+1
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_bullet_t* stage_bullet = stage_enemy->stage_bullet
    // [673] stage_load_enemy::stage_bullet#0 = ((stage_bullet_t **)stage_load_enemy::stage_enemy#0)[OFFSET_STRUCT_STAGE_ENEMY_T_STAGE_BULLET] -- pssz1=qssz2_derefidx_vbuc1 
    ldy #OFFSET_STRUCT_STAGE_ENEMY_T_STAGE_BULLET
    lda (stage_enemy),y
    sta.z stage_bullet
    iny
    lda (stage_enemy),y
    sta.z stage_bullet+1
    // sprite_index_t bullet_sprite = stage_bullet->bullet_sprite
    // [674] stage_load_enemy::bullet_sprite#0 = *((char *)stage_load_enemy::stage_bullet#0) -- vbuaa=_deref_pbuz1 
    ldy #0
    lda (stage_bullet),y
    // fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [675] fe_sprite_bram_load::sprite_index = stage_load_enemy::bullet_sprite#0 -- vbum1=vbuaa 
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_index
    // [676] fe_sprite_bram_load::sprite_offset = *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) -- vwum1=_deref_pwuc1 
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset
    lda equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    sta equinoxe_flightengine.fe_sprite_bram_load.sprite_offset+1
    // [677] callexecute fe_sprite_bram_load  -- call_var_near 
    jsr equinoxe_flightengine.fe_sprite_bram_load
    // [678] stage_load_enemy::$1 = fe_sprite_bram_load::return -- vwum1=vwum2 
    lda equinoxe_flightengine.fe_sprite_bram_load.return
    sta stage_load_enemy__1
    lda equinoxe_flightengine.fe_sprite_bram_load.return+1
    sta stage_load_enemy__1+1
    // stage.sprite_offset = fe_sprite_bram_load(bullet_sprite, stage.sprite_offset)
    // [679] *((unsigned int *)&stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET) = stage_load_enemy::$1 -- _deref_pwuc1=vwum1 
    lda stage_load_enemy__1
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET
    lda stage_load_enemy__1+1
    sta equinoxe_stage_flight.stage+OFFSET_STRUCT_STAGE_T_SPRITE_OFFSET+1
    // stage_load_enemy::@return
    // }
    // [680] return 
    rts
  .segment DataEngineStages
    .label stage_load_enemy__0 = stage_load.stage_load__6
    .label stage_load_enemy__1 = stage_load.stage_load__6
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
    // [681] rand::$0 = rand_state << 7 -- vwum1=vwum2_rol_7 
    lda rand_state+1
    lsr
    lda rand_state
    ror
    sta rand__0+1
    lda #0
    ror
    sta rand__0
    // rand_state ^= rand_state << 7
    // [682] rand_state = rand_state ^ rand::$0 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__0
    sta rand_state
    lda rand_state+1
    eor rand__0+1
    sta rand_state+1
    // rand_state >> 9
    // [683] rand::$1 = rand_state >> 9 -- vwum1=vwum2_ror_9 
    lsr
    sta rand__1
    lda #0
    sta rand__1+1
    // rand_state ^= rand_state >> 9
    // [684] rand_state = rand_state ^ rand::$1 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__1
    sta rand_state
    lda rand_state+1
    eor rand__1+1
    sta rand_state+1
    // rand_state << 8
    // [685] rand::$2 = rand_state << 8 -- vwum1=vwum2_rol_8 
    lda rand_state
    sta rand__2+1
    lda #0
    sta rand__2
    // rand_state ^= rand_state << 8
    // [686] rand_state = rand_state ^ rand::$2 -- vwum1=vwum1_bxor_vwum2 
    lda rand_state
    eor rand__2
    sta rand_state
    lda rand_state+1
    eor rand__2+1
    sta rand_state+1
    // return rand_state;
    // [687] rand::return#0 = rand_state -- vwum1=vwum2 
    lda rand_state
    sta return
    lda rand_state+1
    sta return+1
    // rand::@return
    // }
    // [688] return 
    rts
  .segment Data
    .label rand__0 = stage_bullet_add.sx
    .label rand__1 = stage_bullet_add.sx
    .label rand__2 = stage_bullet_add.sx
    .label return = stage_bullet_add.sx
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
.segment Data
  game: .byte 1, 0, 0
  .word 0
  .byte 0, $7f, $40, 1, 2, $a, $f, $f, 1, -1
 // Asm import library lib_conio:
#define __asm_import__lib_conio__
#import "lib_conio.asm"

 // Asm import library lib_lru_cache:
#define __asm_import__lib_lru_cache__
#import "lib_lru_cache.asm"

 // Asm import library lib_veraheap:
#define __asm_import__lib_veraheap__
#import "lib_veraheap.asm"

 // Asm import library lib_bramheap:
#define __asm_import__lib_bramheap__
#import "lib_bramheap.asm"

 // Asm import library lib_file:
#define __asm_import__lib_file__
#import "lib_file.asm"

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

 // Asm import library equinoxe-waves:
#define __asm_import__equinoxe_waves__
#import "equinoxe-waves.asm"

 // Asm import library equinoxe-stage-flight:
#define __asm_import__equinoxe_stage_flight__
#import "equinoxe-stage-flight.asm"

 // Asm import library equinoxe-enemy:
#define __asm_import__equinoxe_enemy__
#import "equinoxe-enemy.asm"

 // Asm import library equinoxe-collision:
#define __asm_import__equinoxe_collision__
#import "equinoxe-collision.asm"

 // Asm import library cx16_file:
#define __asm_import__cx16_file__
#import "cx16_file.asm"

