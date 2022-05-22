// Create CX16 files containing the program and a sprite file
.file [name="%O", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code", align=$1000]
.segment Basic
:BasicUpstart(%E)
