.file                               [name="%O", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data, CodeVeraHeap, DataVeraHeap"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef CodeVeraHeap            [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeVeraHeap"]
.segmentdef DataVeraHeap            [startAfter="Data", align=$100]
.segmentdef BramVeraHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

.segment Basic
:BasicUpstart(%E)
.segment Code
