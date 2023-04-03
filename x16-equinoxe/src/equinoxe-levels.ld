//.file                               [name="%O", type="prg", segments="Program"]
.file                               [name="STAGES.BIN", type="bin", segments="segm_engine_stages"]
.file                               [name="SPRITES.BIN", type="bin", segments="spritecontrol"]
.file                               [name="FLOORS.BIN", type="bin", segments="floorcontrol"]
//.segmentdef Program                 [segments="Basic, Code, Data"]
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=%P]
.segmentdef Data                    [startAfter="Code"]
.segmentdef spritecontrol           [start=$A000, min=$A000, max=$BF00, align=$100]
.segmentdef floorcontrol            [start=$A000, min=$A000, max=$BF00, align=$100]
.segmentdef levels                  [start=$A000, min=$A000, max=$BFFF, align=$100]
.segment Basic
:BasicUpstart(%E)
.segment Code
.segment Data
.segment segm_engine_stages
.segment spritecontrol
.segment floorcontrol
.segment Data



