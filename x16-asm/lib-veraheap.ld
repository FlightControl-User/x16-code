
#if __veraheap__

#else

.segmentdef Code                    [start=%P]
.segmentdef CodeVeraHeap            [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeVeraHeap"]
.segmentdef DataVeraHeap            [startAfter="Data"]

.segmentdef BramVeraHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

:BasicUpstart(%E)

#endif