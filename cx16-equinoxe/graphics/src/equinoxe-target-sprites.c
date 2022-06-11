
#pragma link("equinoxe-target-sprites.ld")

#include "equinoxe-target-routines.h"


#pragma data_seg(player01)
__export char player01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/player/player01_32x32",7,1,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/player/player01_32x32",pallist,7,1,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/player/player01_32x32",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(enemy01)
__export char enemy01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/enemies/enemy01_32x32",12,0,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/enemies/enemy01_32x32",pallist,12,0,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/enemies/enemy01_32x32",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(enemy02)
__export char enemy02[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/enemies/enemy02_32x32",12,0,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/enemies/enemy02_32x32",pallist,12,0,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/enemies/enemy02_32x32",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(enemy03)
__export char enemy03[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/enemies/enemy03_32x32",06,0,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/enemies/enemy03_32x32",pallist,06,0,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/enemies/enemy03_32x32",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(enemy04)
__export char enemy04[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/enemies/enemy04_32x32",12,0,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/enemies/enemy04_32x32",pallist,12,0,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/enemies/enemy04_32x32",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(enemy05)
__export char enemy05[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/enemies/enemy05_32x32",12,0,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/enemies/enemy05_32x32",pallist,12,0,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/enemies/enemy05_32x32",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(enemy06)
__export char enemy06[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/enemies/enemy06_32x32",12,0,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/enemies/enemy06_32x32",pallist,12,0,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/enemies/enemy06_32x32",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(enemy07)
__export char enemy07[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/enemies/enemy07_32x32",12,0,32,32,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/enemies/enemy07_32x32",pallist,12,0,32,32,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/enemies/enemy07_32x32",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(engine01)
__export char engine01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/engines/engine_red_16x16",16,1,16,16,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/engines/engine_red_16x16",pallist,16,1,16,16,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/engines/engine_red_16x16",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(bullet01)
__export char bullet01[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/bullets/bullet01_16x16",1,0,16,16,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/bullets/bullet01_16x16",pallist,1,0,16,16,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/bullets/bullet01_16x16",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(bullet02)
__export char bullet02[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/bullets/bullet02_16x16",4,0,16,16,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/bullets/bullet02_16x16",pallist,4,0,16,16,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/bullets/bullet02_16x16",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};

#pragma data_seg(bullet03)
__export char bullet03[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/bullets/bullet03_16x16",4,0,16,16,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/bullets/bullet03_16x16",pallist,4,0,16,16,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/bullets/bullet03_16x16",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};
#pragma data_seg(bullet04)
__export char bullet04[] = kickasm {{{
    .var pallist = GetPalette("cx16-equinoxe/graphics/bullets/bullet04_16x16",4,0,16,16,2,1,2,1)
    .var tiledata = MakeTile("cx16-equinoxe/graphics/bullets/bullet04_16x16",pallist,4,0,16,16,2,1,2,1)
    .var pallistdata = MakePalette("cx16-equinoxe/graphics/bullets/bullet04_16x16",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + toHexString(pallistdata.get(i))
    }
};}};
