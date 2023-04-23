#if __bramheap__

#else

.segmentdef Code                    [start=%P]
.segmentdef CodeBramHeap            [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeBramHeap"]
.segmentdef DataBramHeap            [startAfter="Data"]

.segmentdef BramBramHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

:BasicUpstart(%E)

#endif