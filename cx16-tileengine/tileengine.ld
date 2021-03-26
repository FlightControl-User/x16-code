// Create CX16 files containing the program and a sprite file
.file [name="%O", type="prg", segments="Program"]
.file [name="FLOOR01", type="bin", segments="Floor01"]
.file [name="FLOOR02", type="bin", segments="Floor02"]
.file [name="FLOOR03", type="bin", segments="Floor03"]
.file [name="FLOOR04", type="bin", segments="Floor04"]
.file [name="PALETTES", type="bin", segments="Palettes"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
.segmentdef Floor01 
.segmentdef Floor02 
.segmentdef Floor03 
.segmentdef Floor04 
.segmentdef Palettes
