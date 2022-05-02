
#pragma link("equinoxe-target-sprites.ld")

#include "equinoxe-target-routines.h"


#pragma data_seg(Player01)
__export char PLAYER01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/player/player01_32x32",7,1,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/player/player01_32x32",pallist,7,1,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/player/player01_32x32",pallist,16)
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

#pragma data_seg(Enemy01)
__export char ENEMY01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/enemies/enemy01_32x32",12,0,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/enemies/enemy01_32x32",pallist,12,0,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/enemies/enemy01_32x32",pallist,16)
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

#pragma data_seg(Enemy03)
__export char ENEMY03[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/enemies/enemy03_32x32",06,0,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/enemies/enemy03_32x32",pallist,06,0,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/enemies/enemy03_32x32",pallist,16)
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
__export char ENGINE01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/engines/engine_red_16x16",16,1,16,16,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/engines/engine_red_16x16",pallist,16,1,16,16,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/engines/engine_red_16x16",pallist,16)
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

#pragma data_seg(Bullet01)
__export char BULLET01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/bullets/bullet01_16x16",1,0,16,16,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/bullets/bullet01_16x16",pallist,1,0,16,16,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/bullets/bullet01_16x16",pallist,16)
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

#pragma data_seg(Bullet02)
__export char BULLET02[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/bullets/bullet02_16x16",4,0,16,16,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/bullets/bullet02_16x16",pallist,4,0,16,16,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/bullets/bullet02_16x16",pallist,16)
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
