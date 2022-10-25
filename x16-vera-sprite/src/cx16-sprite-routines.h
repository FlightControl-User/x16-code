void main() {}

#pragma data_seg(palettes)
__export char palettes[] = 

kickasm {{

    .struct Sprite {tile, ext, start, count, size, width, height, zorder, flipv, fliph, bpp, collision, reverse, palettecount}

    .macro Seg(seg) {
        .segmentdef seg 
    }
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
                    .var rgb = pic.getPixel(x,y);
                    .var idx = palette.get(rgb)
                    .if(idx==null) {
                        .eval idx = nxt_idx++;
                        .eval palette.put(rgb,idx);
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
                            .var rgb = pic.getPixel(x,y);
                            .var idx1 = palette.get(rgb)
                            .if(idx1==null) {   
                                .error "unknown rgb value!"
                            }
                            .if(hinc>1) {
                                // Find palette index (add if not known)
                                .eval rgb = pic.getPixel(x+1,y);
                                .var idx2 = palette.get(rgb)
                                .if(idx2==null) {
                                    .error "unknown rgb value!"
                                }
                                .eval tiledata.add( idx1*16+idx2 );
                                // .print "idx1 = " + idx1 + ", idx2 = " + idx2
                            } else {
                                .eval tiledata.add(idx1+16);
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

    .function GetPalette2(sprite) {
        .var palette = Hashtable()
        .var palList = List()
        .var nxt_idx = 0;
        .eval palette.put(0,0);
        .eval palList.add(0)
        .var id = sprite.start
        .for(var p=0;p<sprite.count;p++) {
            .var nr = "00"+toIntString(id)
            .var image = sprite.tile + "_" + sprite.width + "x" + sprite.height + "_" + nr.substring(nr.size()-2,nr.size()) + "." + sprite.ext
            .var pic = LoadPicture(image)
            .eval id = id + 1
            .for (var y=0; y<sprite.height; y++) {
                .for (var x=0;x<sprite.width; x++) {
                    // Find palette index (add if not known)
                    .var rgb = pic.getPixel(x,y);
                    .var idx = palette.get(rgb)
                    .if(idx==null) {
                        .eval idx = nxt_idx++;
                        .eval palette.put(rgb,idx);
                        .eval palList.add(rgb)
                        .print "get rgb = " + toHexString(rgb) + " image = " + image + " x = " + x + " y = " + y
                    }
                }
            }
        }
        .return palList
    }

    .function MakeTile2(sprite,pallist) {
        .var palette = Hashtable()
        .print "bpp=" + sprite.bpp
        .for(var p=0;p<pallist.size();p++) {
            .eval palette.put(pallist.get(p),p);
        }
        .var tiledata = List()
        .var id = sprite.start
        .for(var p=0;p<sprite.count;p++) {
            .var nr = "00"+toIntString(id)
            .eval id = id + 1
            .var image = sprite.tile + "_" + sprite.width + "x" + sprite.height + "_" + nr.substring(nr.size()-2,nr.size()) + "." + sprite.ext
            .var pic = LoadPicture(image)
            .var hstep = 8 / sprite.bpp
            .var vstep = 1
            .var hinc = 8 / sprite.bpp
            .var vinc = 1
            .for(var j=0; j<sprite.height; j+=vstep) {
                .for(var i=0; i<sprite.width; i+=hstep) {
                    .for (var y=j; y<j+vstep; y+=vinc) {
                        .for (var x=i; x<i+hstep; x+=hinc) {
                            // Find palette index (add if not known)
                            .var rgb = pic.getPixel(x,y);
                            .var idx1 = palette.get(rgb)
                            .if(idx1==null) {   
                                .error "unknown rgb value!"
                            }
                            .if(hinc>1) {
                                // Find palette index (add if not known)
                                .eval rgb = pic.getPixel(x+1,y);
                                .var idx2 = palette.get(rgb)
                                .if(idx2==null) {
                                    .error "unknown rgb value!"
                                }
                                .eval tiledata.add( idx1*16+idx2 );
                                // .print "idx1 = " + idx1 + ", idx2 = " + idx2
                            } else {
                                .eval tiledata.add(idx1+16);
                            }
                        }
                    }
                }
            }
        }
        .return tiledata
    }


    .function MakePalette2(sprite,pallist) {

        .var palettedata = List()
        .print "put palette size = " + pallist.size()
        .if(pallist.size()>sprite.palettecount) .error "Tile " + sprite.tile + " has too many colours "+pallist.size()
        .for(var i=0;i<sprite.palettecount;i++) {
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
