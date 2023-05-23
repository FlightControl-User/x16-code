.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="STAGES.BIN",         type="bin", segments="CodeEngineStages, BramEngineStages"]
.file                               [name="PLAYERS.BIN",        type="bin", segments="CodeEnginePlayers"]
.file                               [name="BULLETS.BIN",        type="bin", segments="CodeEngineBullets"]
.file                               [name="ENEMIES.BIN",        type="bin", segments="CodeEngineEnemies"]
.file                               [name="TOWERS.BIN",         type="bin", segments="CodeEngineTowers"]
.file                               [name="BRAMFLIGHT1.BIN",    type="bin", segments="BramEngineFlight"]
.file                               [name="BRAMFLOOR1.BIN",     type="bin", segments="BramEngineFloor"]
.file                               [name="VERAHEAP.BIN",       type="bin", segments="BramVeraHeap, CodeVeraHeap, DataVeraHeap"]
.segmentdef Program                 [segments="Basic, Code, Data" + 
                                     ", CodeBramHeap" +
                                     ", CodeLruCache" + 
                                     ", CodeEngineAnimate" +
                                     ", CodeEngineFlight" +
                                     ", CodeEngineFloor" +
                                     ", CodeEnginePalette" +
                                     ", DataBramHeap" +
                                     ", DataEngineAnimate" +
                                     ", DataEngineStages" +
                                     ", DataEngineBullets" +
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
.segmentdef CodeLruCache            [startAfter="CodeBramHeap"] 
.segmentdef CodeEngineAnimate       [startAfter="CodeLruCache"] 
.segmentdef CodeEngineFloor         [startAfter="CodeEngineAnimate"] 
.segmentdef CodeEngineFlight        [startAfter="CodeEngineFloor"] 
.segmentdef CodeEnginePalette       [startAfter="CodeEngineFlight"] 

.segmentdef Data                    [startAfter="CodeEnginePalette", align=$100]
.segmentdef DataBramHeap            [startAfter="Data"] 
.segmentdef DataEngineAnimate       [startAfter="DataBramHeap"] 
.segmentdef DataEngineFloor         [startAfter="DataEngineAnimate"] 
.segmentdef DataEnginePalette       [startAfter="DataEngineFloor"] 
.segmentdef DataEngineStages        [startAfter="DataEnginePalette"]
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

.segmentdef BramVeraHeap            [start=$A000,               min=$A000, max=$BFFF, align=$100]
.segmentdef CodeVeraHeap            [startAfter="BramVeraHeap", min=$A000, max=$BFFF, align=$100] 
.segmentdef DataVeraHeap            [startAfter="CodeVeraHeap", min=$A000, max=$BFFF, align=$100] 

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

