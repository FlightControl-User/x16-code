
#if __animate__
#else
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef Heap                    [startAfter="Data"]
.segmentdef CodeEngineAnimate     [start=$4000, min=$4000, max=$6000]

.segment Basic
:BasicUpstart(%E)
#endif