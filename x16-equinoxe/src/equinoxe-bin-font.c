
#pragma link("equinoxe-bin-tiles.ld")

#include "equinoxe-bin-routines.h"

__export char header[] =kickasm {{
    .struct Tile {tile, ext, start, count, skip, width, height, bpp, palettecount, size}

    .macro Data(sprite, tiledata, pallistdata) {
        // Palette
        .print "palette size = " + pallistdata.size()
        .for(var i=0;i<pallistdata.size();i++) {
            .byte pallistdata.get(i)
            .print "palette " + i + " = " + toHexString(pallistdata.get(i))
        }
        // Fonts
        .print "tiledata.size = " + tiledata.size()
        .for(var i=0;i<tiledata.size();i++) {
            .byte tiledata.get(i)
        }
    }
}};


__export char FONT_01[] = kickasm {{{
    .var tile = Tile("C:/Users/svenv/OneDrive/Documents/GitHub/x16-code/x16-equinoxe/graphics/fonts/galaxy/galaxy-font-sheet","png",0,83,1,16,16,2,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="FONT01.BIN", type="bin", segments="font01"]
    .segmentdef font01
    .segment font01
    Data(tile,tiledata,pallistdata)
};}};

