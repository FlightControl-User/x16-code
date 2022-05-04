
#pragma link("equinoxe-target-tiles.ld")

#include "equinoxe-target-routines.h"

#pragma data_seg(Floor01)
__export char BITMAP_FLOOR01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/floors/8bit/floormetal",30,0,32,32,16,16,1,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/floors/8bit/floormetal",pallist,30,0,32,32,16,16,1,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/floors/8bit/floormetal",pallist,64)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + pallistdata.get(i)
    }
};}};
