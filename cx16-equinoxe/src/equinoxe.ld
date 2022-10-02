.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="LEVELS.BIN", type="bin", segments="levels"]
.file                               [name="SPRITES.BIN", type="bin", segments="spritecontrol"]
.segmentdef Program                 [segments="Basic, Code, Data, TileControl, Heap, fe_sprite_cache"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code", align=$100]
.segmentdef Heap                    [startAfter="Data", align=$100]
.segmentdef TileControl             [startAfter="Heap", align=$100]
.segmentdef fe_sprite_cache         [startAfter="TileControl", align=$100]

.segmentdef Hash                    [start=$0400, min=$0400, max=$07FF, align=$100]

.segmentdef VeraHeap                [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef Palette                 [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef SpriteControlEnemies    [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlBullets    [startAfter="SpriteControlEnemies", min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlPlayer     [startAfter="SpriteControlBullets", min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlEngine     [startAfter="SpriteControlPlayer", min=$A000, max=$BFFF, align=$100]

.segmentdef spritecontrol           [start=$A000, min=$A000, max=$BF00, align=$100]

.segmentdef levels                  [start=$A000, min=$A000, max=$BFFF, align=$100]

.segment Basic
:BasicUpstart(%E)
.segment Code
.segment Data
.segment levels
.segment spritecontrol
.segment Data
