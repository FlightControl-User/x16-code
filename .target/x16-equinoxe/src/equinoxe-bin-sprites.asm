  // File Comments
  // Upstart
.cpu _65c02
  .file [name="PALSPRITE01.BIN", type="bin", segments="palettes"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segmentdef palettes
.segment palettes

  // Global Constants & labels
.segment Code
  // main
// void main()
main: {
    // main::@return
    // [1] return 
    rts
}
  // File Data
.segment palettes
palettes:
.function GetPalette(tile,count,start,width,height,hstep,vstep,hinc,vinc,ext) {
        .var palette = Hashtable()
        .var palList = List()
        .var nxt_idx = 0;
        .eval palette.put(0,0);
        .eval palList.add(0)
        .var id = start
        .for(var p=0;p<count;p++) {
            .var nr = "00"+toIntString(id)
            .var image = tile + "_" + nr.substring(nr.size()-2,nr.size()) + "." + ext
            .var pic = LoadPicture(image)
            .eval id = id + 1
            .for (var y=0; y<height; y++) {
                .for (var x=0;x<width; x++) {
                    // Find palette index (add if not known)
                    .var rgb = pic.getPixel(x,y)
                    .var idx = palette.get(rgb)
                    .if(idx==null) {
                        .eval idx = nxt_idx++
                        .eval palette.put(rgb,idx)
                        .eval palList.add(rgb)
                        .print "get rgb = " + toHexString(rgb) + " image = " + image + " x = " + x + " y = " + y
                    }
                }
            }
        }
        .return palList
    }

    .function MakeTile(tile,pallist,count,start,width,height,hstep,vstep,hinc,vinc,ext) {
        .var palette = Hashtable()
        .for(var p=0;p<pallist.size();p++) {
            .eval palette.put(pallist.get(p),p);
        }
        .var tiledata = List()
        .var id = start
        .for(var p=0;p<count;p++) {
            .var nr = "00"+toIntString(id)
            .eval id = id + 1
            .var image = tile + "_" + nr.substring(nr.size()-2,nr.size()) + "." + ext
            .var pic = LoadPicture(image)
            .for(var j=0; j<height; j+=vstep) {
                .for(var i=0; i<width; i+=hstep) {
                    .for (var y=j; y<j+vstep; y+=vinc) {
                        .for (var x=i; x<i+hstep; x+=hinc) {
                            // Find palette index (add if not known)
                            .var rgb = pic.getPixel(x,y)
                            .var idx1 = palette.get(rgb)
                            .if(idx1==null) {   
                                .error "unknown rgb value!"
                            }
                            .if(hinc>1) {
                                // Find palette index (add if not known)
                                .eval rgb = pic.getPixel(x+1,y)
                                .var idx2 = palette.get(rgb)
                                .if(idx2==null) {
                                    .error "unknown rgb value!"
                                }
                                .eval tiledata.add( idx1*16+idx2 )
                                // .print "idx1 = " + idx1 + ", idx2 = " + idx2
                            } else {
                                .eval tiledata.add(idx1+16)
                            }
                        }
                    }
                }
            }
        }
        .return tiledata
    }


    .function MakePalette(tile,pallist,palettecount) {

        .var palettedata = List()
        .print "put palette size = " + pallist.size()
        .if(pallist.size()>palettecount) .error "Tile " + tile + " has too many colours "+pallist.size()
        .for(var i=0;i<palettecount;i++) {
            .var rgb = 0
            .if(i<pallist.size())
                .eval rgb = pallist.get(i)
            .var green = ((rgb >> 8) & $ff) & $f0
            .var blue = (rgb & $ff) >> 4
            .var red = (rgb >>16) >> 4
            .print "put rgb = " + toHexString(rgb) + " green = " + toHexString(green) + " blue = " + toHexString(blue) + " red = " + toHexString(red)
            // bits 4-8: green, bits 0-3 blue
            .eval palettedata.add(green | blue)
            // bits bits 0-3 red
            .eval palettedata.add(red)
            // .printnow "tile large: rgb = " + rgb + ", i = " + i
        }
        .return palettedata
    }

    .function GetPalette2(bitmap) {
        .var palette = Hashtable()
        .var palList = List()
        .var nxt_idx = 0;
        .eval palette.put(0,0);
        .eval palList.add(0)
        .var id = bitmap.start
        .eval bitmap.size = (bitmap.width * bitmap.height) / (8 / bitmap.bpp)
        .eval bitmap.count = round((bitmap.count / bitmap.skip))
        .print "count = " + bitmap.count + "size = " + bitmap.size + ", width = " + bitmap.width + ", height = " + bitmap.height + ", bpp = " + bitmap.bpp
        .for(var p=0;p<bitmap.count;p++) {
            .var nr = "00"+toIntString(id)
            .var image = bitmap.tile + "_" + bitmap.width + "x" + bitmap.height + "_" + nr.substring(nr.size()-2,nr.size()) + "." + bitmap.ext
            .var pic = LoadPicture(image)
            .eval id = id + bitmap.skip
            .for (var y=0; y<bitmap.height; y++) {
                .for (var x=0;x<bitmap.width; x++) {
                    // Find palette index (add if not known)
                    .var rgb = pic.getPixel(x,y)
                    .var idx = palette.get(rgb)
                    .if(idx==null) {
                        .eval idx = nxt_idx++
                        .eval palette.put(rgb,idx)
                        .eval palList.add(rgb)
                        .print "get rgb = " + toHexString(rgb) + " image = " + image + " x = " + x + " y = " + y
                    }
                }
            }
        }
        .return palList
    }

    .function MakeTile2(bitmap,pallist) {
        .var palette = Hashtable()
        .print "bpp=" + bitmap.bpp
        .for(var p=0;p<pallist.size();p++) {
            .eval palette.put(pallist.get(p),p);
        }
        .var tiledata = List()
        .var id = bitmap.start
        .for(var p=0;p<bitmap.count;p++) {
            .var nr = "00"+toIntString(id)
            .var image = bitmap.tile + "_" + bitmap.width + "x" + bitmap.height + "_" + nr.substring(nr.size()-2,nr.size()) + "." + bitmap.ext
            .var pic = LoadPicture(image)
            .var hstep = 8 / bitmap.bpp
            .var vstep = 1
            .var hinc = 8 / bitmap.bpp
            .var vinc = 1
            .eval id = id + bitmap.skip
            .for(var j=0; j<bitmap.height; j+=vstep) {
                .for(var i=0; i<bitmap.width; i+=hstep) {
                    .for (var y=j; y<j+vstep; y+=vinc) {
                        .for (var x=i; x<i+hstep; x+=hinc) {
                            // Find palette index (add if not known)
                            .var rgb = pic.getPixel(x,y)
                            .var idx1 = palette.get(rgb)
                            .if(idx1==null) {   
                                .error "unknown rgb value!"
                            }
                            .if(hinc>1) {
                                // Find palette index (add if not known)
                                .eval rgb = pic.getPixel(x+1,y)
                                .var idx2 = palette.get(rgb)
                                .if(idx2==null) {
                                    .error "unknown rgb value!"
                                }
                                .eval tiledata.add( idx1*16+idx2 )
                                // .print "idx1 = " + idx1 + ", idx2 = " + idx2
                            } else {
                                .eval tiledata.add(idx1+16)
                            }
                        }
                    }
                }
            }
        }
        .return tiledata
    }


    .function MakePalette2(bitmap,pallist) {

        .var palettedata = List()
        .print "put palette size = " + pallist.size()
        .if(pallist.size()>bitmap.palettecount) .error "Tile " + bitmap.tile + " has too many colours "+pallist.size()
        .for(var i=0;i<bitmap.palettecount;i++) {
            .var rgb = 0
            .if(i<pallist.size())
                .eval rgb = pallist.get(i)
            .var green = ((rgb >> 8) & $ff) & $f0
            .var blue = (rgb & $ff) >> 4
            .var red = (rgb >>16) >> 4
            .print "put rgb = " + toHexString(rgb) + " green = " + toHexString(green) + " blue = " + toHexString(blue) + " red = " + toHexString(red)
            // bits 4-8: green, bits 0-3 blue
            .eval palettedata.add(green | blue)
            // bits bits 0-3 red
            .eval palettedata.add(red)
            // .printnow "tile large: rgb = " + rgb + ", i = " + i
        }
        .return palettedata
    }

    .function GetPalette3(bitmap) {
        .var palette = Hashtable()
        .var palList = List()
        .var nxt_idx = 0;
        .eval palette.put(0,0);
        .eval palList.add(0)
        .eval bitmap.size = (bitmap.width * bitmap.height) / (8 / bitmap.bpp)
        .eval bitmap.count = round((bitmap.count / bitmap.skip))
        .print "count = " + bitmap.count + "size = " + bitmap.size + ", width = " + bitmap.width + ", height = " + bitmap.height + ", bpp = " + bitmap.bpp
        .var image = bitmap.tile + "_" + bitmap.width + "x" + bitmap.height + "." + bitmap.ext
        .print image
        .var pic = LoadPicture(image)
        .var xoff = bitmap.width * bitmap.start
        .var yoff = 0
        .for(var p=0;p<bitmap.count;p++) {
            .for (var y=0; y<bitmap.height; y++) {
                .for (var x=xoff;x<bitmap.width+xoff; x++) {
                    // Find palette index (add if not known)
                    .var rgb = pic.getPixel(x,y)
                    .var idx = palette.get(rgb)
                    .if(idx==null) {
                        .eval idx = nxt_idx++
                        .eval palette.put(rgb,idx)
                        .eval palList.add(rgb)
                        .print "get rgb = " + toHexString(rgb) + " image = " + image + " x = " + x + " y = " + y
                    }
                }
            }
            .eval xoff += bitmap.width * bitmap.skip
        }
        .return palList
    }

    .function MakeTile3(bitmap,pallist) {
        .var palette = Hashtable()
        .print "bpp=" + bitmap.bpp
        .for(var p=0;p<pallist.size();p++) {
            .eval palette.put(pallist.get(p),p);
        }
        .var tiledata = List()
        .var image = bitmap.tile + "_" + bitmap.width + "x" + bitmap.height + "." + bitmap.ext
        .var pic = LoadPicture(image)
        .var xoff = bitmap.width * bitmap.start
        .var yoff = 0
        .for(var p=0;p<bitmap.count;p++) {
            .var hstep = 8 / bitmap.bpp
            .var vstep = 1
            .var hinc = 8 / bitmap.bpp
            .var vinc = 1
            .print "bitmap = " + p
            .for(var j=0; j<bitmap.height; j+=vstep) {
                .print "j = " + j
                .for(var i=0+xoff; i<bitmap.width+xoff; i+=hstep) {
                    .print "i = " + i
                    .for (var y=j; y<j+vstep; y+=vinc) {
                        .print "y = " + y
                        .for (var x=i; x<i+hstep; x+=hinc) {
                            .print "x = " + x
                            // Find palette index (add if not known)
                            .var rgb = pic.getPixel(x,y)
                            .var idx1 = palette.get(rgb)
                            .if(idx1==null) {   
                                .error "unknown rgb value!"
                            }
                            .if(hinc>1) {
                                // Find palette index (add if not known)
                                .eval rgb = pic.getPixel(x+1,y)
                                .var idx2 = palette.get(rgb)
                                .if(idx2==null) {
                                    .error "unknown rgb value!"
                                }
                                .eval tiledata.add( idx1*16 + idx2);
                                // .print "idx1 = " + idx1 + ", idx2 = " + idx2
                            } else {
                                .eval tiledata.add(idx1 + 16);
                            }
                        }
                    }
                }
            }
            .eval xoff += bitmap.width * bitmap.skip
        }
        .return tiledata
    }

    .function MakePalette3(bitmap,pallist) {
        .var palettedata = List()
        .print "put palette size = " + pallist.size()
        .if(pallist.size()>bitmap.palettecount) .error "Tile " + bitmap.tile + " has too many colours "+pallist.size()
        .for(var i=0;i<bitmap.palettecount;i++) {
            .var rgb = 0
            .if(i<pallist.size())
                .eval rgb = pallist.get(i)
            .var green = ((rgb >> 8) & $ff) & $f0
            .var blue = (rgb & $ff) >> 4
            .var red = (rgb >>16) >> 4
            .print "put rgb = " + toHexString(rgb) + " green = " + toHexString(green) + " blue = " + toHexString(blue) + " red = " + toHexString(red)
            // bits 4-8: green, bits 0-3 blue
            .eval palettedata.add(green | blue)
            // bits bits 0-3 red
            .eval palettedata.add(red)
            // .printnow "tile large: rgb = " + rgb + ", i = " + i
        }
        .return palettedata
    }


header:
.struct Sprite {tile, ext, start, count, skip, size, width, height, zorder, flipv, fliph, bpp, collision, reverse, palettecount, loop}

    .macro Data(sprite, tiledata, pallistdata) {
        // Header
        .byte sprite.count, <sprite.size, >sprite.size, sprite.width, sprite.height, sprite.zorder, sprite.fliph, sprite.flipv, sprite.bpp, sprite.collision, sprite.reverse, sprite.loop,0,0,0,0

        // Palette
        .print "palette size = " + pallistdata.size()
        .for(var i=0;i<pallistdata.size();i++) {
            .byte pallistdata.get(i)
            .print "palette " + i + " = " + toHexString(pallistdata.get(i))
        }

        // Sprite
        .print "tiledata.size = " + tiledata.size()
        .for(var i=0;i<tiledata.size();i++) {
            .byte tiledata.get(i)
        }
    }



t001:
{
    .var sprite = Sprite("../graphics/floors/towers/tower_gun_01","png",0,12,1,512,32,32,2,0,0,4,2,0,16,0)
    .var pallist = GetPalette3(sprite)
    .var tiledata = MakeTile3(sprite,pallist)
    .var pallistdata = MakePalette3(sprite,pallist)
    .file [name="T001.BIN", type="bin", segments="t001"]
    .segmentdef t001
    .segment t001
    Data(sprite,tiledata,pallistdata)
};
p001:
{
    .var sprite = Sprite("../graphics/player/p001_sheet","png",0,17,1,512,32,32,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette3(sprite)
    .var tiledata = MakeTile3(sprite,pallist)
    .var pallistdata = MakePalette3(sprite,pallist)
    .file [name="P001.BIN", type="bin", segments="p001"]
    .segmentdef p001
    .segment p001
    Data(sprite,tiledata,pallistdata)
};
n001:
{
    .var sprite = Sprite("../graphics/engines/n001","png",1,16,1,128,16,16,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="N001.BIN", type="bin", segments="n001"]
    .segmentdef n001
    .segment n001
    Data(sprite,tiledata,pallistdata)
};
e0101:
{
    .var sprite = Sprite("../graphics/enemies/e0101","gif",0,12,1,512,64,64,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0101.BIN", type="bin", segments="e0101"]
    .segmentdef e0101
    .segment e0101
    Data(sprite,tiledata,pallistdata)
};
e0102:
{
    .var sprite = Sprite("../graphics/enemies/e0102","gif",0,12,1,512,64,64,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0102.BIN", type="bin", segments="e0102"]
    .segmentdef e0102
    .segment e0102
    Data(sprite,tiledata,pallistdata)
};
e0201:
{
    .var sprite = Sprite("../graphics/enemies/e0201","gif",0,12,1,512,64,64,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0201.BIN", type="bin", segments="e0201"]
    .segmentdef e0201
    .segment e0201
    Data(sprite,tiledata,pallistdata)
};
e0202:
{
    .var sprite = Sprite("../graphics/enemies/e0202","gif",0,12,1,512,64,64,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0202.BIN", type="bin", segments="e0202"]
    .segmentdef e0202
    .segment e0202
    Data(sprite,tiledata,pallistdata)
};
e0301:
{
    .var sprite = Sprite("../graphics/enemies/e0301","gif",0,12,1,512,64,64,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0301.BIN", type="bin", segments="e0301"]
    .segmentdef e0301
    .segment e0301
    Data(sprite,tiledata,pallistdata)
};
e0302:
{
    .var sprite = Sprite("../graphics/enemies/e0302","gif",0,12,1,512,64,64,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0302.BIN", type="bin", segments="e0302"]
    .segmentdef e0302
    .segment e0302
    Data(sprite,tiledata,pallistdata)
};
e0401:
{
    .var sprite = Sprite("../graphics/enemies/e0401","gif",0,14,1,512,32,32,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0401.BIN", type="bin", segments="e0401"]
    .segmentdef e0401
    .segment e0401
    Data(sprite,tiledata,pallistdata)
};
e0501:
{
    .var sprite = Sprite("../graphics/enemies/e0501","gif",0,13,1,512,32,32,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0501.BIN", type="bin", segments="e0501"]
    .segmentdef e0501
    .segment e0501
    Data(sprite,tiledata,pallistdata)
};
e0502:
{
    .var sprite = Sprite("../graphics/enemies/e0502","gif",0,14,1,512,32,32,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0502.BIN", type="bin", segments="e0502"]
    .segmentdef e0502
    .segment e0502
    Data(sprite,tiledata,pallistdata)
};
e0601:
{
    .var sprite = Sprite("../graphics/enemies/e0601","gif",0,13,1,512,32,32,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0601.BIN", type="bin", segments="e0601"]
    .segmentdef e0601
    .segment e0601
    Data(sprite,tiledata,pallistdata)
};
e0602:
{
    .var sprite = Sprite("../graphics/enemies/e0602","gif",0,13,1,512,32,32,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0602.BIN", type="bin", segments="e0602"]
    .segmentdef e0602
    .segment e0602
    Data(sprite,tiledata,pallistdata)
};
e0701:
{
    .var sprite = Sprite("../graphics/enemies/e0701","gif",0,13,1,512,32,32,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0701.BIN", type="bin", segments="e0701"]
    .segmentdef e0701
    .segment e0701
    Data(sprite,tiledata,pallistdata)
};
e702:
{
    .var sprite = Sprite("../graphics/enemies/e0702","gif",0,13,1,512,32,32,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0702.BIN", type="bin", segments="e0702"]
    .segmentdef e0702
    .segment e0702
    Data(sprite,tiledata,pallistdata)
};
e703:
{
    .var sprite = Sprite("../graphics/enemies/e0703","gif",0,13,1,512,32,32,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="E0703.BIN", type="bin", segments="e0703"]
    .segmentdef e0703
    .segment e0703
    Data(sprite,tiledata,pallistdata)
};
b001:
{
    .var sprite = Sprite("../graphics/bullets/b001","png",0,1,1,128,16,16,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="B001.BIN", type="bin", segments="b001"]
    .segmentdef b001
    .segment b001
    Data(sprite,tiledata,pallistdata)
};
b002:
{
    .var sprite = Sprite("../graphics/bullets/b002","png",0,16,1,128,16,16,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette3(sprite)
    .var tiledata = MakeTile3(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="B002.BIN", type="bin", segments="b002"]
    .segmentdef b002
    .segment b002
    Data(sprite,tiledata,pallistdata)
};
b003:
{
    .var sprite = Sprite("../graphics/bullets/b003","png",0,2,1,512,16,64,3,0,1,4,2,0,16,0)
    .var pallist = GetPalette3(sprite)
    .var tiledata = MakeTile3(sprite,pallist)
    .var pallistdata = MakePalette3(sprite,pallist)
    .file [name="B003.BIN", type="bin", segments="b003"]
    .segmentdef b003
    .segment b003
    Data(sprite,tiledata,pallistdata)
};
b004:
{
    .var sprite = Sprite("../graphics/bullets/b004","png",0,4,1,128,16,16,3,0,0,4,2,0,16,0)
    .var pallist = GetPalette2(sprite)
    .var tiledata = MakeTile2(sprite,pallist)
    .var pallistdata = MakePalette2(sprite,pallist)
    .file [name="B004.BIN", type="bin", segments="b004"]
    .segmentdef b004
    .segment b004
    Data(sprite,tiledata,pallistdata)
};
