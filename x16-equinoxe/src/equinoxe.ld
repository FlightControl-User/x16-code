.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="STAGES.BIN", type="bin", segments="CodeEngineStages, BramEngineStages"]
.file                               [name="BULLETS.BIN", type="bin", segments="CodeEngineBullets"]
.file                               [name="ENEMIES.BIN", type="bin", segments="CodeEngineEnemies"]
.file                               [name="BRAMFLIGHT1.BIN", type="bin", segments="BramEngineFlight"]
.file                               [name="BRAMFLOOR1.BIN", type="bin", segments="BramEngineFloor"]
//.file                             [name="PLAYERS.BIN", type="bin", segments="CodeEnginePlayers"]
.segmentdef Program                 [segments="Basic, Code, Data" + 
                                     ", CodeBramHeap" +
                                     ", CodeVeraHeap" +
                                     ", CodeLruCache" + 
                                     ", CodeEnginePlayers" +
                                     ", CodeEngineAnimate" +
                                     ", CodeEngineFlight" +
                                     ", CodeEngineFloor" +
                                     ", CodeEnginePalette" +
                                     ", DataBramHeap" +
                                     ", DataVeraHeap" +
                                     ", DataEngineStages" +
                                     ", DataEnginePlayers" +
                                     ", DataEngineEnemies" +
                                     ", DataEngineFlight" +
                                     ", DataEngineFloor" +
                                     ", DataEnginePalette" +
//                                     ", BramEngineFloor" +
                                     ", DataSpriteCache"
                                     ]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef CodeBramHeap            [startAfter="Code"] 
.segmentdef CodeVeraHeap            [startAfter="CodeBramHeap"] 
.segmentdef CodeLruCache            [startAfter="CodeVeraHeap"] 
.segmentdef CodeEnginePlayers       [startAfter="CodeLruCache"] 
.segmentdef CodeEngineAnimate       [startAfter="CodeEnginePlayers"] 
.segmentdef CodeEngineFloor         [startAfter="CodeEngineAnimate"] 
.segmentdef CodeEngineFlight        [startAfter="CodeEngineFloor"] 
.segmentdef CodeEnginePalette       [startAfter="CodeEngineFlight"] 

.segmentdef Data                    [startAfter="CodeEnginePalette", align=$100]
.segmentdef DataBramHeap            [startAfter="Data"] 
.segmentdef DataVeraHeap            [startAfter="DataBramHeap"] 
.segmentdef DataEngineFloor         [startAfter="DataVeraHeap"] 
//.segmentdef BramEngineFloor       [startAfter="DataEngineFloor"] 
.segmentdef DataEngineFlight        [startAfter="DataEngineFloor"] 
.segmentdef DataEnginePalette       [startAfter="DataEngineFlight"] 
.segmentdef DataEngineStages        [startAfter="DataEnginePalette"]
.segmentdef DataEnginePlayers       [startAfter="DataEngineStages"]
.segmentdef DataEngineEnemies       [startAfter="DataEnginePlayers"]
.segmentdef DataSpriteCache         [startAfter="DataEngineEnemies", align=$100]


.segmentdef hash                    [start=$0400, min=$0400, max=$07FF, align=$100]

.segmentdef BramBramHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef BramVeraHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineTowers        [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineStages        [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef BramEngineStages        [startAfter="CodeEngineStages", min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineBullets       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineEnemies       [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef BramEngineFloor         [start=$A000, min=$A000, max=$BF00, align=$100]
.segmentdef BramEngineFlight        [start=$A000, min=$A000, max=$BF00, align=$100]
.segmentdef BramEnginePalette       [start=$A000, min=$A000, max=$BFFF, align=$100]

//.segmentdef CodeEngineTowers      [start=$A000, min=$A000, max=$BFFF, align=$100]
//.segmentdef CodeEngineFloor         [start=$A000, min=$A000, max=$BF00, align=$100]
//.segmentdef CodeEnginePlayers     [start=$A000, min=$A000, max=$BFFF, align=$100]
//.segmentdef CodeEngineFlight        [start=$A000, min=$A000, max=$BFFF, align=$100]

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

