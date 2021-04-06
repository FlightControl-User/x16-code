
#pragma link("Flightengine.ld")

void main() {}

#pragma data_seg(Palettes)
export char PALETTES[] = 

kickasm {{
    .function GetPalette(tile,count,start,width,height,hinc,vinc) {
        .var palette = Hashtable()
        .var palList = List()
        .var nxt_idx = 0;
        .eval palette.put(0,0);
        .eval palList.add(0)
        .var id = start
        .for(var p=0;p<count;p++) {
            .var nr = "00"+toIntString(id)
            .var image = tile + "_" + nr.substring(nr.size()-2,nr.size()) + ".png"
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
                        .print "get rgb = " + rgb + " image = " + image + " x = " + x + " y = " + y
                    }
                }
            }
        }
        .return palList
    }

    .function MakeTile(tile,pallist,count,start,width,height,hinc,vinc) {
        .var palette = Hashtable()
        .for(var p=0;p<pallist.size();p++) {
            .eval palette.put(pallist.get(p),p);
        }
        .var tiledata = List()
        .var id = start
        .for(var p=0;p<count;p++) {
            .var nr = "00"+toIntString(id)
            .eval id = id + 1
            .var image = tile + "_" + nr.substring(nr.size()-2,nr.size()) + ".png"
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


#pragma data_seg(Player01)
export char BITMAP_PLAYER01[] = kickasm {{{
    .var pallist = GetPalette("Ship/Player01",7,1,32,32,2,1)
    .var tiledata = MakeTile("Ship/Player01",pallist,7,1,32,32,2,1)
    .var pallistdata = MakePalette("Ship/Player01",pallist,16)
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

