
#pragma link("equinoxe-target-tiles.ld")

#include "equinoxe-target-routines.h"

__export char header[] =kickasm {{
    .var palette_offset = 0;
}};

#pragma data_seg(Floor01)
__export char BITMAP_FLOOR01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/floors/8bit/floormetal",30,0,32,32,16,16,1,1,"png")
    .var tiledata = MakeTile("cx16-equinoxe/graphics/floors/8bit/floormetal",pallist,30,0,32,32,16,16,1,1,"png")
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/floors/8bit/floormetal",pallist,64)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + pallistdata.get(i)
    }
};}};
