// Create CX16 files containing the program and a sprite file
.file [name="%O", type="prg", segments="Program"]
.file [name="PLAYER01.BIN", type="bin", segments="player01"]
.file [name="ENGINE01.BIN", type="bin", segments="engine01"]
.file [name="ENEMY01.BIN", type="bin", segments="enemy01"]
.file [name="ENEMY02.BIN", type="bin", segments="enemy02"]
.file [name="ENEMY03.BIN", type="bin", segments="enemy03"]
.file [name="ENEMY04.BIN", type="bin", segments="enemy04"]
.file [name="ENEMY05.BIN", type="bin", segments="enemy05"]
.file [name="ENEMY06.BIN", type="bin", segments="enemy06"]
.file [name="ENEMY07.BIN", type="bin", segments="enemy07"]
.file [name="ENEMY08.BIN", type="bin", segments="enemy08"]
.file [name="ENEMY09.BIN", type="bin", segments="enemy09"]
.file [name="ENEMY10.BIN", type="bin", segments="enemy10"]
.file [name="BULLET01.BIN", type="bin", segments="bullet01"]
.file [name="BULLET02.BIN", type="bin", segments="bullet02"]
.file [name="BULLET03.BIN", type="bin", segments="bullet01"]
.file [name="BULLET04.BIN", type="bin", segments="bullet02"]
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
.segmentdef enemy05
.segmentdef enemy06
.segmentdef enemy07
.segmentdef enemy08
.segmentdef enemy09
.segmentdef enemy10
.segmentdef engine01 
.segmentdef bullet01 
.segmentdef bullet02 
.segmentdef bullet03 
.segmentdef bullet04 
.segmentdef palettes
