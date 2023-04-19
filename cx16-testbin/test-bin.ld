//.file                               [name="%O", type="prg", segments="Program"]
//.file                               [name="TEST.BIN", type="bin", segments="segm_test_bin"]
//.segmentdef Program                 [segments="Basic, Code, Data"]
//.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
//.segmentdef Heap                    [startAfter="Data"]
.segmentdef segm_test_bin           [start=$4000, min=$4000]


//.segment Basic
//:BasicUpstart(%E)
.segment segm_test_bin
//.segment Data
//.segment Code
