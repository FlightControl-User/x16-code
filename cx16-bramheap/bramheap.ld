.file                               [name="%O", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef DataBramHeap            [start=$8000, min=$8000, max=$9F00]
.segmentdef CodeBramHeap            [start=$8000, min=$8000, max=$9F00]
.segmentdef BramBramHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

.segment Basic
:BasicUpstart(%E)
