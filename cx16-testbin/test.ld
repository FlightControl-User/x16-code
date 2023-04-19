.file                               [name="%O", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data, segm_test_bin"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef Heap                    [startAfter="Data"]
.segmentdef segm_test_bin           [start=$4000, min=$4000]

.segment Basic
:BasicUpstart(%E)
.segment segm_test_bin
.segment Data
.segment Code

