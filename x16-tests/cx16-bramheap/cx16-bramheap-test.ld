.file                               [name="%O", type="prg", segments="Program"]
.segmentdef Program                 [segments="Basic, Code, Data, CodeBramHeap, DataBramHeap"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef CodeBramHeap            [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeBramHeap"]
.segmentdef DataBramHeap            [start=$6000, min=$6000, max=$9FFF, align=$100]
.segmentdef BramBramHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

.segment Basic
:BasicUpstart(%E)
.segment Code
