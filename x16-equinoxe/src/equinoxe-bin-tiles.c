
#pragma link("equinoxe-bin-tiles.ld")

#include "equinoxe-bin-routines.h"

__export char header[] =kickasm {{
    .struct Tile {tile, ext, start, count, skip, width, height, bpp, palettecount, size}

    .macro Data(sprite, tiledata, pallistdata) {
        // Header
        //.byte sprite.count, <sprite.size, >sprite.size, sprite.width, sprite.height, sprite.zorder, sprite.fliph, sprite.flipv, sprite.bpp, sprite.collision, sprite.reverse, sprite.loop,0,0,0,0

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


__export char MARS_LAND[] = kickasm {{{
    .var tile = Tile("C:/Users/svenv/OneDrive/Documents/GitHub/x16-code/x16-equinoxe/graphics/floors/mars01/mars-land_sheet","png",1,72,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="MARSLAND.BIN", type="bin", segments="mars_land"]
    .segmentdef mars_land
    .segment mars_land
    Data(tile,tiledata,pallistdata)
};}};

__export char MARS_SAND[] = kickasm {{{
    .var tile = Tile("C:/Users/svenv/OneDrive/Documents/GitHub/x16-code/x16-equinoxe/graphics/floors/mars01/mars-sand_sheet","png",1,4,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="MARSSAND.BIN", type="bin", segments="mars_sand"]
    .segmentdef mars_sand
    .segment mars_sand
    Data(tile,tiledata,pallistdata)
};}};

__export char MARS_SEA[] = kickasm {{{
    .var tile = Tile("C:/Users/svenv/OneDrive/Documents/GitHub/x16-code/x16-equinoxe/graphics/floors/mars01/mars-sea_sheet","png",1,16,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="MARSSEA.BIN", type="bin", segments="mars_sea"]
    .segmentdef mars_sea
    .segment mars_sea
    Data(tile,tiledata,pallistdata)
};}};


__export char METAL_YELLOW[] = kickasm {{{
    .var tile = Tile("C:/Users/svenv/OneDrive/Documents/GitHub/x16-code/x16-equinoxe/graphics/floors/metal/metal-yellow2_sheet","png",1,40,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="METALYELLOW.BIN", type="bin", segments="metalyellow"]
    .segmentdef metalyellow
    .segment metalyellow
    Data(tile,tiledata,pallistdata)
};}};

__export char METAL_RED[] = kickasm {{{
    .var tile = Tile("C:/Users/svenv/OneDrive/Documents/GitHub/x16-code/x16-equinoxe/graphics/floors/metal/metal-grey_sheet","png",1,1,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="METALRED.BIN", type="bin", segments="metalred"]
    .segmentdef metalred
    .segment metalred
    Data(tile,tiledata,pallistdata)
};}};

__export char METAL_GREY[] = kickasm {{{
    .var tile = Tile("C:/Users/svenv/OneDrive/Documents/GitHub/x16-code/x16-equinoxe/graphics/floors/metal/metal-red_sheet","png",1,1,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="METALGREY.BIN", type="bin", segments="metalgrey"]
    .segmentdef metalgrey
    .segment metalgrey
    Data(tile,tiledata,pallistdata)
};}};
