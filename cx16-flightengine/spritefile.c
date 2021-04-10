
#pragma link("spritefile.ld")

#include "../cx16-include/bitmapfile.h"


#pragma data_seg(Player01)
export char BITMAP_PLAYER01[] = kickasm {{{
    .var pallist = GetPalette("Ship/Player01",7,1,32,32,2,1,2,1)
    .var tiledata = MakeTile("Ship/Player01",pallist,7,1,32,32,2,1,2,1)
    .var pallistdata = MakePalette("Ship/Player01",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(Engine01)
export char BITMAP_ENGINE01[] = kickasm {{{
    .var pallist = GetPalette("Flame/flame_engine_red_16x16",16,1,16,16,2,1,2,1)
    .var tiledata = MakeTile("Flame/flame_engine_red_16x16",pallist,16,1,16,16,2,1,2,1)
    .var pallistdata = MakePalette("Flame/flame_engine_red_16x16",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};
