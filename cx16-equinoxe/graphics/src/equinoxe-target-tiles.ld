// Create CX16 files containing the program and a sprite file
.file [name="%O", type="prg", segments="Program"]
.file [name="FLOOR01.BIN", type="bin", segments="Floor01"]
.file [name="PALFLOOR01.BIN", type="bin", segments="Palettes"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
.segmentdef Floor01 
.segmentdef Palettes
