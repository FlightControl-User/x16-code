
#pragma link("c128-sprites.ld")

#include "c128-resources.h"

__export char header[] =kickasm {{

    .struct Sprite {tile, ext, start, count, skip, size, width, height, zorder, flipv, fliph, bpp, collision, reverse, palettecount, loop}

    .macro Data(sprite, tiledata, pallistdata) {
        // Header
//        .byte sprite.count, sprite.size, sprite.width, sprite.height, sprite.zorder, sprite.fliph, sprite.flipv, sprite.bpp, sprite.collision, sprite.reverse, sprite.loop,0,0,0,0

        // Sprite
        .print "tiledata.size = " + tiledata.size()
        .var col = 0
        .var line = ""
        .for(var i=0;i<tiledata.size();i++) {
            .eval line = line.string() + toBinaryString(tiledata.get(i),8) + " "
            .eval col = col + 1
            .if(col == sprite.width / 8) {
                .eval col = 0
                .print line 
                .eval line = ""
            }
            .byte tiledata.get(i)
        }
    }
}};

__export char fly[] = kickasm {{{
    .var sprite = Sprite("graphics/flies/fly_01","png",0,1,1,32,16,16,2,0,0,1,2,0,2,1)
    .var pallist = GetPalette(sprite)
    .var tiledata = MakeTile(sprite,pallist)
    .var pallistdata = MakePalette(sprite,pallist)
    .file [name="fly_01.bin", type="bin", segments="fly_01"]
    .segmentdef fly_01
    .segment fly_01
    Data(sprite,tiledata,pallistdata)
};}};

