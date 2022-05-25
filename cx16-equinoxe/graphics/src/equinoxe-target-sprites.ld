// Create CX16 files containing the program and a sprite file
.file [name="%O", type="prg", segments="Program"]
.file [name="PLAYER01.BIN", type="bin", segments="player01"]
.file [name="ENEMY01.BIN", type="bin", segments="enemy01"]
.file [name="ENEMY02.BIN", type="bin", segments="enemy02"]
.file [name="ENEMY03.BIN", type="bin", segments="enemy03"]
.file [name="ENEMY04.BIN", type="bin", segments="enemy04"]
.file [name="ENGINE01.BIN", type="bin", segments="engine01"]
.file [name="BULLET01.BIN", type="bin", segments="bullet01"]
.file [name="BULLET02.BIN", type="bin", segments="bullet02"]
.file [name="PALSPRITE01.BIN", type="bin", segments="palettes"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
.segmentdef player01 
.segmentdef enemy01 
.segmentdef enemy02 
.segmentdef enemy03 
.segmentdef enemy04
.segmentdef engine01 
.segmentdef bullet01 
.segmentdef bullet02 
.segmentdef palettes
