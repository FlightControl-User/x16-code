.file                               [name="%O", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data, CodeVeraHeap"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef CodeVeraHeap      [startAfter="Data"]
.segmentdef BramVeraHeap     [start=$A000, min=$A000, max=$BFFF, align=$100]

.segment Basic
:BasicUpstart(%E)
.segment CodeVeraHeap
.segment Data
.segment Code
