.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="STAGE.BIN", type="bin", segments="stage"]
.file                               [name="SPRITES.BIN", type="bin", segments="spritecontrol"]
.file                               [name="FLOORS.BIN", type="bin", segments="floorcontrol"]
.segmentdef Program                 [segments="Basic, Code, Data, Heap, fe_sprite_cache"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef Heap                    [startAfter="Data"]
.segmentdef fe_sprite_cache         [startAfter="Heap"]

.segmentdef hash                    [start=$0400, min=$0400, max=$07FF, align=$100]

.segmentdef VeraHeap                [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef Palette                 [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef SpriteControlEnemies    [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlBullets    [startAfter="SpriteControlEnemies", min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlPlayer     [startAfter="SpriteControlBullets", min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlEngine     [startAfter="SpriteControlPlayer", min=$A000, max=$BFFF, align=$100]
.segmentdef TileControlTowers       [startAfter="SpriteControlEngine", min=$A000, max=$BFFF, align=$100]
.segmentdef sprite_animate_control  [startAfter="TileControlTowers", min=$A000, max=$BFFF, align=$100]

.segmentdef stage                   [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef floorcontrol            [start=$A000, min=$A000, max=$BF00, align=$100]

.segmentdef spritecontrol           [start=$A000, min=$A000, max=$BF00, align=$100]

.segment Basic
:BasicUpstart(%E)
.segment Code
.segment floorcontrol
.segment spritecontrol
.segment stage
.segment Data
.segment Code
