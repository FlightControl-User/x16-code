
#if __animate__
#else
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef CodeEngineAnimate       [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeEngineAnimate"]
.segmentdef DataEngineAnimate       [startAfter="Data"]

.segment Basic
:BasicUpstart(%E)
#endif