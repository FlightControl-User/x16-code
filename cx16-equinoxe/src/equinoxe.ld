.file [name="%O", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data, EnemyControl, SpriteControl, TileControl, Hash"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code", align=$100]
.segmentdef EnemyControl [startAfter="Data", align=$100]
.segmentdef SpriteControl [startAfter="EnemyControl", align=$100]
.segmentdef TileControl [startAfter="SpriteControl", align=$100]
.segmentdef Hash [startAfter="TileControl", align=$100]
.segmentdef Palette [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlEnemies [start=$A800, min=$A800, max=$BFFF, align=$100]
.segmentdef SpriteControlBullets [startAfter="SpriteControlEnemies", min=$A800, max=$BFFF, align=$100]
.segmentdef SpriteControlPlayer  [startAfter="SpriteControlBullets", min=$A800, max=$BFFF, align=$100]
.segmentdef SpriteControlEngine  [startAfter="SpriteControlPlayer", min=$A800, max=$BFFF, align=$100]
.segment Basic
:BasicUpstart(%E)
.segment Code
.segment Data
.segment EnemyControl
.segment SpriteControl
.segment TileControl
.segment Hash
//.segmentdef Heap [startAfter="Data"]
//.segmentdef Sprite [startAfter="Heap"]
//.segmentdef Hash [startAfter="Data"]
