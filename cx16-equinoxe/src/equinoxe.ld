.file [name="%O", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data, EnemyControl, SpriteControl, TileControl, Hash, Heap"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code", align=$100]
.segmentdef Hash [startAfter="Data", align=$100]
.segmentdef Heap [startAfter="Hash", align=$100]
.segmentdef TileControl [startAfter="Heap", align=$100]
.segmentdef SpriteControl [startAfter="TileControl", align=$100]
.segmentdef EnemyControl [startAfter="SpriteControl", align=$100]

.segmentdef VeraHeap             [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef Palette              [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef SpriteControlEnemies [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlBullets [startAfter="SpriteControlEnemies", min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlPlayer  [startAfter="SpriteControlBullets", min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlEngine  [startAfter="SpriteControlPlayer", min=$A000, max=$BFFF, align=$100]
.segment Basic
:BasicUpstart(%E)
.segment Code
.segment Data
.segment Hash
.segment Heap
.segment TileControl
.segment SpriteControl
.segment EnemyControl
//.segmentdef Heap [startAfter="Data"]
//.segmentdef Sprite [startAfter="Heap"]
//.segmentdef Hash [startAfter="Data"]
