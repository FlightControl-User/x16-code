.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="BANK3.BIN", type="bin", segments="Bank3"]
.segmentdef Program                 [segments="Basic, Code, Data"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef Bank3                   [start=$A000, min=$A000, max=$BFFF, align=$100]
.segment Basic
:BasicUpstart(%E)
.segment Bank3
.segment Code
.segment Data
