.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="STAGES.BIN", type="bin", segments="CodeEngineStages"]
.file                               [name="BULLETS.BIN", type="bin", segments="CodeEngineBullets"]
.file                               [name="ENEMIES.BIN", type="bin", segments="CodeEngineEnemies"]
.file                               [name="SPRITES.BIN", type="bin", segments="DataEngineSprites"]
.file                               [name="FLOORS.BIN", type="bin", segments="CodeEngineFloor"]
//.file                             [name="PLAYERS.BIN", type="bin", segments="CodeEnginePlayers"]
.segmentdef Program                 [segments="Basic, Code, Data" + 
                                     ", Heap" + 
                                     ", CodeVeraHeap" +
                                     ", CodeLruCache" + 
                                     ", CodeEngineAnimate" +
                                     ", DataEngineStages" +
                                     ", DataEnginePlayers" +
                                     ", DataEngineEnemies" +
//                                     ", DataEngineFlight" +
                                     ", DataEngineFloor" +
                                     ", DataSpriteCache"
                                     ]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef CodeVeraHeap            [startAfter="Code"] 
.segmentdef CodeLruCache            [startAfter="CodeVeraHeap"] 
.segmentdef CodeEngineAnimate       [startAfter="CodeLruCache"] 
.segmentdef Data                    [startAfter="CodeEngineAnimate", align=$100]
.segmentdef Heap                    [startAfter="Data", align=$100]
.segmentdef DataEngineStages        [startAfter="Heap"]
.segmentdef DataEnginePlayers       [startAfter="DataEngineStages"]
.segmentdef DataEngineEnemies       [startAfter="DataEnginePlayers"]
//.segmentdef DataEngineFlight        [startAfter="DataEngineEnemies", align=$100]
.segmentdef DataEngineFloor         [startAfter="DataEngineEnemies", align=$100]
.segmentdef DataSpriteCache         [startAfter="DataEngineFloor", align=$100]


.segmentdef hash                    [start=$0400, min=$0400, max=$07FF, align=$100]

.segmentdef BramVeraHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEnginePlayers       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineTowers        [startAfter="CodeEnginePlayers", min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineFlight        [startAfter="CodeEngineTowers", min=$A000, max=$BFFF, align=$100]
.segmentdef DataEngineFlight        [startAfter="CodeEngineFlight", align=$100]
.segmentdef CodeEngineStages        [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineBullets       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineEnemies       [start=$A000, min=$A000, max=$BFFF, align=$100]
//.segmentdef CodeEnginePlayers     [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef CodeEngineFloor         [start=$A000, min=$A000, max=$BF00, align=$100]
.segmentdef Palette                 [start=$A000, min=$A000, max=$BFFF, align=$100]
//.segmentdef CodeEngineTowers      [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef DataEngineSprites       [start=$A000, min=$A000, max=$BF00, align=$100]

.segment Basic
:BasicUpstart(%E)
.segment Code
.segment CodeEngineFloor
.segment CodeEngineFlight
.segment CodeEngineStages
.segment CodeEngineBullets
.segment CodeEngineEnemies
.segment CodeEnginePlayers
.segment Data
.segment Code

