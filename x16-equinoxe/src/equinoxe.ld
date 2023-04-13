.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="STAGES.BIN", type="bin", segments="segm_engine_stages"]
.file                               [name="BULLETS.BIN", type="bin", segments="segm_engine_bullets"]
.file                               [name="ENEMIES.BIN", type="bin", segments="segm_engine_enemies"]
.file                               [name="SPRITES.BIN", type="bin", segments="spritecontrol"]
.file                               [name="FLOORS.BIN", type="bin", segments="segm_engine_floor"]
.segmentdef Program                 [segments="Basic, Code, Data, Heap, fe_sprite_cache"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef Heap                    [startAfter="Data"]
.segmentdef fe_sprite_cache         [startAfter="Heap"]

.segmentdef hash                    [start=$0400, min=$0400, max=$07FF, align=$100]

.segmentdef VeraHeap                [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef Palette                 [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef SpriteControlPlayer     [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef SpriteControlEngine     [startAfter="SpriteControlPlayer", min=$A000, max=$BFFF, align=$100]
.segmentdef TileControlTowers       [startAfter="SpriteControlEngine", min=$A000, max=$BFFF, align=$100]

.segmentdef segm_engine_stages      [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef segm_engine_bullets     [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef segm_engine_enemies     [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef segm_engine_floor       [start=$A000, min=$A000, max=$BF00, align=$100]

.segmentdef spritecontrol           [start=$A000, min=$A000, max=$BF00, align=$100]

.segment Basic
:BasicUpstart(%E)
.segment Code
.segment segm_engine_floor
.segment spritecontrol
.segment segm_engine_stages
.segment segm_engine_bullets
.segment segm_engine_enemies
.segment Data
.segment Code
