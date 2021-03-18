// Create CX16 files containing the program and a sprite file
.file [name="%O", type="prg", segments="Program"]
.file [name="BORDER", type="bin", segments="Border"]
.file [name="SQUAREMETAL", type="bin", segments="SquareMetal"]
.file [name="SQUARERASTER", type="bin", segments="SquareRaster"]
.file [name="INSIDEMETAL", type="bin", segments="InsideMetal"]
.file [name="INSIDEDARK", type="bin", segments="InsideDark"]
.file [name="PALETTES", type="bin", segments="Palettes"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=%P]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(%E)
.segmentdef Border 
.segmentdef SquareMetal 
.segmentdef SquareRaster 
.segmentdef InsideMetal
.segmentdef InsideDark 
.segmentdef Palettes
