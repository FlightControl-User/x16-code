
#pragma link("tileengine.ld")

void main() {}

#pragma data_seg(Palettes)
export char PALETTES[] = 

kickasm {{
    .function GetPalette(tile,count,width,height,hinc,vinc) {
        .var palette = Hashtable()
        .var palList = List()
        .var nxt_idx = 0;
        .eval palette.put(0,0);
        .eval palList.add(0)
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
                        .print "get rgb = " + rgb + " image = " + image + " x = " + x + " y = " + y
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
        .print "put palette size = " + pallist.size()
        .if(pallist.size()>palettecount) .error "Tile " + tile + " has too many colours "+pallist.size()
        .for(var i=0;i<pallist.size();i++) {
            .var rgb = 0
            .if(i<pallist.size())
                .eval rgb = pallist.get(i)
            .print "put rgb = " + rgb
            .var red = ceil(rgb / [256*256])
            .var green = ceil((rgb/256)) & 255
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


#pragma data_seg(Floor01)
export char BITMAP_FLOOR01[] = kickasm {{{
    .var pallist = GetPalette("Floor_01_White_Border",20,32,32,16,16)
    .var tiledata = MakeTile("Floor_01_White_Border",pallist,20,32,32,16,16)
    .var pallistdata = MakePalette("Floor_01_White_Border",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + pallistdata.get(i)
    }
};}};

#pragma data_seg(Floor02)
export char BITMAP_FLOOR02[] = kickasm {{{
    .var pallist = GetPalette("Floor_01_Lava_Inner",4,32,32,16,16)
    .var tiledata = MakeTile("Floor_01_Lava_Inner",pallist,4,32,32,16,16)
    .var pallistdata = MakePalette("Floor_01_Lava_Inner",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + pallistdata.get(i)
    }
};}};

#pragma data_seg(Floor03)
export char BITMAP_FLOOR03[] = kickasm {{{
    .var pallist = GetPalette("Floor_01_Lava_Black",16,32,32,16,16)
    .var tiledata = MakeTile("Floor_01_Lava_Black",pallist,16,32,32,16,16)
    .var pallistdata = MakePalette("Floor_01_Lava_Black",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + pallistdata.get(i)
    }
};}};

#pragma data_seg(Floor04)
export char BITMAP_FLOOR04[] = kickasm {{{
    .var pallist = GetPalette("Floor_01_Lava_White",16,32,32,16,16)
    .var tiledata = MakeTile("Floor_01_Lava_White",pallist,16,32,32,16,16)
    .var pallistdata = MakePalette("Floor_01_Lava_White",pallist,16)
    .for(var i=0;i<tiledata.size();i++) {
        .byte tiledata.get(i)
    }
    .segment Palettes
    .print "palette size = " + pallistdata.size()
    .for(var i=0;i<pallistdata.size();i++) {
        .byte pallistdata.get(i)
        .print "palette " + i + " = " + pallistdata.get(i)
    }
};}};
