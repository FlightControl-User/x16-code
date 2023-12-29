  // File Comments
  // Upstart
.cpu _65c02
  .file [name="PALFLOOR01.BIN", type="bin", segments="palettes"]
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

MARS_LAND:
{
    .var tile = Tile("../graphics/floors/mars01/mars-land_sheet","png",1,94,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="MARSLAND.BIN", type="bin", segments="mars_land"]
    .segmentdef mars_land
    .segment mars_land
    Data(tile,tiledata,pallistdata)
};
MARS_SAND:
{
    .var tile = Tile("../graphics/floors/mars01/mars-sand_sheet","png",1,4,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="MARSSAND.BIN", type="bin", segments="mars_sand"]
    .segmentdef mars_sand
    .segment mars_sand
    Data(tile,tiledata,pallistdata)
};
MARS_SEA:
{
    .var tile = Tile("../graphics/floors/mars01/mars-sea_sheet","png",1,16,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="MARSSEA.BIN", type="bin", segments="mars_sea"]
    .segmentdef mars_sea
    .segment mars_sea
    Data(tile,tiledata,pallistdata)
};
METAL_YELLOW:
{
    .var tile = Tile("../graphics/floors/metal/metal-yellow2_sheet","png",1,42,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="METALYELLOW.BIN", type="bin", segments="metalyellow"]
    .segmentdef metalyellow
    .segment metalyellow
    Data(tile,tiledata,pallistdata)
};
METAL_RED:
{
    .var tile = Tile("../graphics/floors/metal/metal-grey_sheet","png",1,1,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="METALRED.BIN", type="bin", segments="metalred"]
    .segmentdef metalred
    .segment metalred
    Data(tile,tiledata,pallistdata)
};
METAL_GREY:
{
    .var tile = Tile("../graphics/floors/metal/metal-red_sheet","png",1,1,1,16,16,4,16,0)
    .var pallist = GetPalette3(tile)
    .var tiledata = MakeTile3(tile,pallist)
    .var pallistdata = MakePalette3(tile,pallist)
    .file [name="METALGREY.BIN", type="bin", segments="metalgrey"]
    .segmentdef metalgrey
    .segment metalgrey
    Data(tile,tiledata,pallistdata)
};
