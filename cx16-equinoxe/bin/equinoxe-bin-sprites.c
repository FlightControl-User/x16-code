
#pragma link("equinoxe-bin-sprites.ld")

#include "equinoxe-bin-routines.h"

__export char header[] =kickasm {{
    .var palette_offset = 0;

    .struct Sprite {tile, ext, start, count, skip, size, width, height, zorder, flipv, fliph, bpp, collision, reverse, palettecount}

    .macro Data(sprite, tiledata, pallistdata) {
        .byte sprite.count, <sprite.size, >sprite.size, sprite.width, sprite.height, sprite.zorder, sprite.fliph, sprite.flipv, sprite.bpp, sprite.collision, sprite.reverse, palette_offset,0,0,0,0
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

__export char p001[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/player/p001","png",1,7,1,512,32,32,3,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="P001.BIN", type="bin", segments="p001"]
    .segmentdef p001
    .segment p001
    Data(sprite,tiledata,pallistdata)
};}};

__export char n001[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/engines/n001","png",1,16,1,128,16,16,3,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="N001.BIN", type="bin", segments="n001"]
    .segmentdef n001
    .segment n001
    Data(sprite,tiledata,pallistdata)
};}};

__export char e0101[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0101","gif",0,12,1,512,64,64,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0101.BIN", type="bin", segments="e0101"]
    .segmentdef e0101
    .segment e0101
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0102[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0102","gif",0,12,1,512,64,64,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0102.BIN", type="bin", segments="e0102"]
    .segmentdef e0102
    .segment e0102
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0201[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0201","gif",0,12,1,512,64,64,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0201.BIN", type="bin", segments="e0201"]
    .segmentdef e0201
    .segment e0201
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0202[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0202","gif",0,12,1,512,64,64,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0202.BIN", type="bin", segments="e0202"]
    .segmentdef e0202
    .segment e0202
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0301[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0301","gif",0,12,1,512,64,64,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0301.BIN", type="bin", segments="e0301"]
    .segmentdef e0301
    .segment e0301
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0302[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0302","gif",0,12,1,512,64,64,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0302.BIN", type="bin", segments="e0302"]
    .segmentdef e0302
    .segment e0302
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0401[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0401","gif",0,14,1,512,32,32,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0401.BIN", type="bin", segments="e0401"]
    .segmentdef e0401
    .segment e0401
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0501[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0501","gif",0,13,1,512,32,32,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0501.BIN", type="bin", segments="e0501"]
    .segmentdef e0501
    .segment e0501
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0502[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0502","gif",0,14,1,512,32,32,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0502.BIN", type="bin", segments="e0502"]
    .segmentdef e0502
    .segment e0502
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0601[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0601","gif",0,13,1,512,32,32,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0601.BIN", type="bin", segments="e0601"]
    .segmentdef e0601
    .segment e0601
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0602[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0602","gif",0,13,1,512,32,32,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0602.BIN", type="bin", segments="e0602"]
    .segmentdef e0602
    .segment e0602
    Data(sprite,tiledata,pallistdata)
};}};


__export char e0701[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0701","gif",0,13,1,512,32,32,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0701.BIN", type="bin", segments="e0701"]
    .segmentdef e0701
    .segment e0701
    Data(sprite,tiledata,pallistdata)
};}};

__export char e702[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0702","gif",0,13,1,512,32,32,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0702.BIN", type="bin", segments="e0702"]
    .segmentdef e0702
    .segment e0702
    Data(sprite,tiledata,pallistdata)
};}};

__export char e703[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/enemies/e0703","gif",0,13,1,512,32,32,3,0,0,4,2,1,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0703.BIN", type="bin", segments="e0703"]
    .segmentdef e0703
    .segment e0703
    Data(sprite,tiledata,pallistdata)
};}};



__export char b001[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/bullets/b001","png",0,1,1,128,16,16,3,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="B001.BIN", type="bin", segments="b001"]
    .segmentdef b001
    .segment b001
    Data(sprite,tiledata,pallistdata)
};}};

__export char b002[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/bullets/b002","png",0,4,1,128,16,16,3,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="B002.BIN", type="bin", segments="b002"]
    .segmentdef b002
    .segment b002
    Data(sprite,tiledata,pallistdata)
};}};

__export char b003[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/bullets/b003","png",0,4,1,128,16,16,3,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="B003.BIN", type="bin", segments="b003"]
    .segmentdef b003
    .segment b003
    Data(sprite,tiledata,pallistdata)
};}};

__export char b004[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/bullets/b004","png",0,4,1,128,16,16,3,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="B004.BIN", type="bin", segments="b004"]
    .segmentdef b004
    .segment b004
    Data(sprite,tiledata,pallistdata)
};}};

__export char t001[] = kickasm {{{
    .var sprite = Sprite("cx16-equinoxe/graphics/floors/towers/tower_gun_01","png",0,12,1,512,32,32,3,0,0,4,2,0,16)
    .var pallist = GetPalette3(sprite)
    .var tiledata = MakeTile3(sprite,pallist)
    .var pallistdata = MakePalette3(sprite,pallist)
    .file [name="T001.BIN", type="bin", segments="t001"]
    .segmentdef t001
    .segment t001
    Data(sprite,tiledata,pallistdata)
};}};
