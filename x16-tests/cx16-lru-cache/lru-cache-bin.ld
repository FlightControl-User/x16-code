.file                               [name="%O", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data, CodeLruCache"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef CodeLruCache      [startAfter="Data"]

.segment Basic
:BasicUpstart(%E)
