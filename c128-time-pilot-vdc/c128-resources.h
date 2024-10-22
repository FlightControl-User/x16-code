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


__export char functions[] = 

kickasm {{

    .function GetPalette(bitmap) {
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

    .function MakeTile(bitmap,pallist) {
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
//            .print "bitmap = " + p
            .for(var j=0; j<bitmap.height; j+=vstep) {
//                .print "j = " + j
                .for(var i=0+xoff; i<bitmap.width+xoff; i+=hstep) {
//                    .print "i = " + i
                    .for (var y=j; y<j+vstep; y+=vinc) {
//                        .print "y = " + y
                        .for (var x=i; x<i+hstep; x+=hinc) {
//                            .print "x = " + x
                            .var val = 0
                            .for(var v=0; v<hinc; v++) {
                                // Find palette index (add if not known)
                                .var rgb = pic.getPixel(x+v,y)
                                //.print "rgb == " + rgb
                                .if(rgb == 0) {
                                    .eval val = val * 2;
                                } else {
                                    .eval val = val * 2 + 1;
                                }
                            }
                            //.print "val = " + val
                            .eval tiledata.add(val);
                        }
                    }
                }
            }
            .eval xoff += bitmap.width * bitmap.skip
        }
        .return tiledata
    }

    .function MakePalette(bitmap,pallist) {
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

}};
