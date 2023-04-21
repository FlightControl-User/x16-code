.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="VERAHEAP.BIN", type="bin", segments="CodeVeraHeap"]
.segmentdef Program                 [segments="Basic, Code, Data"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef CodeVeraHeap      [start=$8000, min=$8000, max=$9F00]
.segmentdef BramVeraHeap     [start=$A000, min=$A000, max=$BFFF, align=$100]

.segment Basic
:BasicUpstart(%E)
.segment CodeVeraHeap
.segment Data
.segment Code
