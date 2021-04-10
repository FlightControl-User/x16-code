
#pragma link("tilefile.ld")

#include "../cx16-include/bitmapfile.h"


#pragma data_seg(Floor01)
export char BITMAP_FLOOR01[] = kickasm {{{
    .var pallist = GetPalette("Floor/Floor_01_White_Border",20,0,32,32,16,16,2,1)
    .var tiledata = MakeTile("Floor/Floor_01_White_Border",pallist,20,0,32,32,16,16,2,1)
    .var pallistdata = MakePalette("Floor/Floor_01_White_Border",pallist,16)
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

#pragma data_seg(Floor02)
export char BITMAP_FLOOR02[] = kickasm {{{
    .var pallist = GetPalette("Floor/Floor_01_Lava_Inner",4,0,32,32,16,16,2,1)
    .var tiledata = MakeTile("Floor/Floor_01_Lava_Inner",pallist,4,0,32,32,16,16,2,1)
    .var pallistdata = MakePalette("Floor/Floor_01_Lava_Inner",pallist,16)
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

#pragma data_seg(Floor03)
export char BITMAP_FLOOR03[] = kickasm {{{
    .var pallist = GetPalette("Floor/Floor_01_Lava_Black",16,0,32,32,16,16,2,1)
    .var tiledata = MakeTile("Floor/Floor_01_Lava_Black",pallist,16,0,32,32,16,16,2,1)
    .var pallistdata = MakePalette("Floor/Floor_01_Lava_Black",pallist,16)
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

#pragma data_seg(Floor04)
export char BITMAP_FLOOR04[] = kickasm {{{
    .var pallist = GetPalette("Floor/Floor_01_Lava_White",16,0,32,32,16,16,2,1)
    .var tiledata = MakeTile("Floor/Floor_01_Lava_White",pallist,16,0,32,32,16,16,2,1)
    .var pallistdata = MakePalette("Floor/Floor_01_Lava_White",pallist,16)
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
