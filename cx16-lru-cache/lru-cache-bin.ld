.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="LRUCACHE.BIN", type="bin", segments="CodeLruCache"]
.segmentdef Program                 [segments="Basic, Code, Data"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef Heap                    [startAfter="Data"]
.segmentdef CodeLruCache      [start=$4000, min=$4000, max=$6000]

.segment Basic
:BasicUpstart(%E)
.segment CodeLruCache
.segment Data
.segment Code
