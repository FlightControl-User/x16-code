// Create CX16 files containing the program and a sprite file
.file [name="%O", type="prg", segments="Program"]
.file [name="PLAYER01.BIN", type="bin", segments="Player01"]
.file [name="ENEMY01.BIN", type="bin", segments="Enemy01"]
.file [name="ENGINE01", type="bin", segments="Engine01"]
.file [name="BULLET01", type="bin", segments="Bullet01"]
.file [name="BULLET02", type="bin", segments="Bullet02"]
.file [name="PALETTES", type="bin", segments="Palettes"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
.segmentdef Player01 
.segmentdef Enemy01 
.segmentdef Engine01 
.segmentdef Bullet01 
.segmentdef Bullet02 
.segmentdef Palettes
