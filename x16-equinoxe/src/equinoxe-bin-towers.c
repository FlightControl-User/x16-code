
#pragma link("equinoxe-bin-towers.ld")

#include "equinoxe-bin-routines.h"

__export char header[] =kickasm {{

    .struct Tile {tile, ext, start, count, skip, width, height, bpp, palettecount, size}

    .macro Data(tile, tiledata, pallistdata) {
        // Palette
        .print "palette size = " + pallistdata.size()
        .for(var i=0;i<pallistdata.size();i++) {
            .byte pallistdata.get(i)
            .print "palette " + i + " = " + toHexString(pallistdata.get(i))
        }

        // Tiles
        .print "tiledata.size = " + tiledata.size()
        .for(var i=0;i<tiledata.size();i++) {
            .byte tiledata.get(i)
        }
    }
}};


__export char TOWER_01[] = kickasm {{{
    .var tile = Tile("D:/Users/svenv/OneDrive/Documents/GitHub/x16-code/x16-equinoxe/graphics/floors/towers/tower_base","png",1,16,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="TOWER01.BIN", type="bin", segments="tower01"]
    .segmentdef tower01
    .segment tower01
    Data(tile,tiledata,pallistdata)
};}};

