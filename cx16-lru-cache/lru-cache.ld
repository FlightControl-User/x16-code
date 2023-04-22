
#if __lru_cache__
#else
.segmentdef Code                    [start=%P]
.segmentdef CodeLruCache            [startAfter="Code"]
.segmentdef Data                    [startAfter="CodeLruCache"]

:BasicUpstart(%E)
#endif