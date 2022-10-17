
#pragma link("equinoxe-bin-tiles.ld")

#include "equinoxe-bin-routines.h"

__export char header[] =kickasm {{
    .var palette_offset = 0;

    .struct Tile {tile, ext, start, count, skip, width, height, bpp, palettecount, size}

    .macro Data(sprite, tiledata, pallistdata) {
        .for(var i=0;i<tiledata.size();i++) {
            .byte tiledata.get(i)
        }
        .segment palettes
        .print "palette size = " + pallistdata.size()
        .for(var i=0;i<pallistdata.size();i++) {
            .byte pallistdata.get(i)
            .print "palette " + i + " = " + toHexString(pallistdata.get(i))
        }
        .eval palette_offset = palette_offset + 1
    }
}};


__export char FLOOR_01[] = kickasm {{{
    .var tile = Tile("cx16-equinoxe/graphics/floors/8bit/floor_yellow_metal","png",0,21,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="FLOOR01.BIN", type="bin", segments="floor01"]
    .segmentdef floor01
    .segment floor01
    Data(tile,tiledata,pallistdata)
};}};

__export char FLOOR_02[] = kickasm {{{
    .var tile = Tile("cx16-equinoxe/graphics/floors/8bit/floor_metal","png",1,1,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="FLOOR02.BIN", type="bin", segments="floor02"]
    .segmentdef floor02
    .segment floor02
    Data(tile,tiledata,pallistdata)
};}};

__export char FLOOR_03[] = kickasm {{{
    .var tile = Tile("cx16-equinoxe/graphics/floors/8bit/floor_red_metal","png",1,1,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="FLOOR03.BIN", type="bin", segments="floor03"]
    .segmentdef floor03
    .segment floor03
    Data(tile,tiledata,pallistdata)
};}};
