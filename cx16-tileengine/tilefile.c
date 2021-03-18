
#pragma link("tileengine.ld")

void main() {}

#pragma data_seg(Palettes)
export char PALETTES[] = 

kickasm {{
    .function GetPalette(tile,count,width,height,hinc,vinc) {
        .var palette = Hashtable()
        .var palList = List()
        .var nxt_idx = 0;
        .for(var p=0;p<count;p++) {
            .var nr = "00"+toIntString(p)
            .var image = "Floor/" + tile + "_" + nr.substring(nr.size()-2,nr.size()) + ".png"
            .var pic = LoadPicture(image)
            .for (var y=0; y<height; y++) {
                .for (var x=0;x<width; x++) {
                    // Find palette index (add if not known)
                    .var rgb = pic.getPixel(x,y);
                    .var idx = palette.get(rgb)
                    .if(idx==null) {
                        .eval idx = nxt_idx++;
                        .eval palette.put(rgb,idx);
                        .eval palList.add(rgb)
                        .print "get rgb = " + rgb
                    }
                }
            }
        }
        .return palList
    }

    .function MakeTile(tile,pallist,count,width,height,hinc,vinc) {
        .var palette = Hashtable()
        .for(var p=0;p<pallist.size();p++) {
            .eval palette.put(pallist.get(p),p);
        }
        .var tiledata = List()
        .for(var p=0;p<count;p++) {
            .var nr = "00"+toIntString(p)
            .var image = "Floor/" + tile + "_" + nr.substring(nr.size()-2,nr.size()) + ".png"
            .var pic = LoadPicture(image)
            .for(var j=0; j<height; j+=vinc) {
                .for(var i=0; i<width; i+=hinc) {
                    .for (var y=j; y<j+vinc; y++) {
                        .for (var x=i; x<i+hinc; x+=2) {
                            // Find palette index (add if not known)
                            .var rgb = pic.getPixel(x,y);
                            .var idx1 = palette.get(rgb)
                            .if(idx1==null) {   
                                .error "unknown rgb value!"
                            }
                            // Find palette index (add if not known)
                            .eval rgb = pic.getPixel(x+1,y);
                            .var idx2 = palette.get(rgb)
                            .if(idx2==null) {
                                .error "unknown rgb value!"
                            }
                            .eval tiledata.add( idx1*16+idx2 );
                        }
                    }
                }
            }
        }
        .return tiledata
    }


    .function MakePalette(tile,pallist,palettecount) {

        .var palettedata = List()
        .if(pallist.size()>palettecount) .error "Tile " + tile + " has too many colours "+pallist.size()
        .for(var i=0;i<palettecount;i++) {
            .var rgb = 0
            .if(i<pallist.size())
                .eval rgb = pallist.get(i)
            .print "put rgb = " + rgb
            .var red = floor(rgb / [256*256])
            .var green = floor((rgb/256)) & 255
            .var blue = rgb & 255
            // bits 4-8: green, bits 0-3 blue
            .eval palettedata.add(green&$f0 | blue/16)
            // bits bits 0-3 red
            .eval palettedata.add(red/16)
            // .printnow "tile large: rgb = " + rgb + ", i = " + i
        }
        .return palettedata
    }
}};


#pragma data_seg(Border)
export char BITMAP_BORDER[] = kickasm {{{
    .var pallist = GetPalette("Border",24,32,32,16,16)
    .var tiledata = MakeTile("Border",pallist,24,32,32,16,16)
    .var pallistdata = MakePalette("Border",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
    }
};}};

#pragma data_seg(SquareMetal)
export char BITMAP_SQUAREMETAL[] = kickasm {{{
    .var pallist = GetPalette("SquareMetal",16,32,32,16,16)
    .var tiledata = MakeTile("SquareMetal",pallist,16,32,32,16,16)
    .var pallistdata = MakePalette("SquareMetal",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
    }
};}};

#pragma data_seg(SquareRaster)
export char BITMAP_SQUARERASTER[] = kickasm {{{
    .var pallist = GetPalette("SquareRaster",16,32,32,16,16)
    .var tiledata = MakeTile("SquareRaster",pallist,16,32,32,16,16)
    .var pallistdata = MakePalette("SquareRaster",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
    }
};}};

#pragma data_seg(InsideMetal)
export char BITMAP_INSIDEMETAL[] = kickasm {{{
    .var pallist = GetPalette("InsideMetal",1,32,32,16,16)
    .var tiledata = MakeTile("InsideMetal",pallist,1,32,32,16,16)
    .var pallistdata = MakePalette("InsideMetal",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
    }
};}};

#pragma data_seg(InsideDark)
export char BITMAP_INSIDEDARK[] = kickasm {{{
    .var pallist = GetPalette("InsideDark",1,32,32,16,16)
    .var tiledata = MakeTile("InsideDark",pallist,1,32,32,16,16)
    .var pallistdata = MakePalette("InsideDark",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
    }
};}};

