
#pragma link("cx16-sprites.ld")

#include "cx16-sprite-routines.h"

__export char header[] =kickasm {{
    .var palette_offset = 0;
}};

__export char s48x8[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,8*8/2,8,8,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S408X08.BIN", type="bin", segments="s408x08"]
    .segmentdef s408x08
    .segment s408x08
    Data(sprite,tiledata,pallistdata)
};}};

__export char s416x8[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,16*8/2,16,8,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S416X08.BIN", type="bin", segments="s416x08"]
    .segmentdef s416x08
    .segment s416x08
    Data(sprite,tiledata,pallistdata)
};}};

__export char s432x8[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,32*8/2,32,8,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S432X08.BIN", type="bin", segments="s432x08"]
    .segmentdef s432x08
    .segment s432x08
    Data(sprite,tiledata,pallistdata)
};}};

__export char s464x8[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,64*8/2,64,8,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S464X08.BIN", type="bin", segments="s464x08"]
    .segmentdef s464x08
    .segment s464x08
    Data(sprite,tiledata,pallistdata)
};}};

__export char s408x16[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,8*16/2,8,16,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S408X16.BIN", type="bin", segments="s408x16"]
    .segmentdef s408x16
    .segment s408x16
    Data(sprite,tiledata,pallistdata)
};}};

__export char s408x32[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,8*32/2,8,32,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S408X32.BIN", type="bin", segments="s408x32"]
    .segmentdef s408x32
    .segment s408x32
    Data(sprite,tiledata,pallistdata)
};}};

__export char s408x64[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,8*64/2,8,64,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S408X64.BIN", type="bin", segments="s408x64"]
    .segmentdef s408x64
    .segment s408x64
    Data(sprite,tiledata,pallistdata)
};}};

__export char s416x16[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,16*16/2,16,16,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S416X16.BIN", type="bin", segments="s416x16"]
    .segmentdef s416x16
    .segment s416x16
    Data(sprite,tiledata,pallistdata)
};}};


__export char s432x16[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,32*16/2,32,16,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S432X16.BIN", type="bin", segments="s432x16"]
    .segmentdef s432x16
    .segment s432x16
    Data(sprite,tiledata,pallistdata)
};}};


__export char s416x32[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,16*32/2,16,32,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S416X32.BIN", type="bin", segments="s416x32"]
    .segmentdef s416x32
    .segment s416x32
    Data(sprite,tiledata,pallistdata)
};}};

__export char s416x64[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,16*64/2,16,64,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S416X64.BIN", type="bin", segments="s416x64"]
    .segmentdef s416x64
    .segment s416x64
    Data(sprite,tiledata,pallistdata)
};}};

__export char s464x16[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,64*16/2,64,16,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S464X16.BIN", type="bin", segments="s464x16"]
    .segmentdef s464x16
    .segment s464x16
    Data(sprite,tiledata,pallistdata)
};}};


__export char s432x32[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,32*32/2,32,32,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S432X32.BIN", type="bin", segments="s432x32"]
    .segmentdef s432x32
    .segment s432x32
    Data(sprite,tiledata,pallistdata)
};}};


__export char s464x32[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,64*32/2,64,32,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S464X32.BIN", type="bin", segments="s464x32"]
    .segmentdef s464x32
    .segment s464x32
    Data(sprite,tiledata,pallistdata)
};}};


__export char s432x64[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,32*64/2,32,64,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S432X64.BIN", type="bin", segments="s432x64"]
    .segmentdef s432x64
    .segment s432x64
    Data(sprite,tiledata,pallistdata)
};}};


__export char s464x64[] = kickasm {{{
    .var sprite = Sprite("cx16-vera-sprite/graphics/s4","gif",1,1,64*64/2,64,64,1,0,0,4,2,0,16)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="S464X64.BIN", type="bin", segments="s464x64"]
    .segmentdef s464x64
    .segment s464x64
    Data(sprite,tiledata,pallistdata)
};}};
