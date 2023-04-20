.file                               [name="%O", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef CodeEnginePalette       [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeEnginePalette"]
.segmentdef DataEnginePalette       [startAfter="Data"]
.segmentdef BramEnginePalette       [start=$A000, min=$A000, max=$BFFF]

.segment Basic
:BasicUpstart(%E)
.segment CodeEnginePalette
.segment Data
.segment Code
