// Example program for the Commander X16

#pragma link("space.ld")

#pragma zp_reserve(0x80..0xA8)

#pragma data_seg(Data)

#include <cx16.h>
#include <cx16-kernal.h>
#include <6502.h>
#include <veralib.h>
#include <conio.h>
#include <printf.h>
#include <stdio.h>
#include <division.h>
#include <mos6522.h>

const byte NUM_PLAYER = 12;
const byte NUM_ENEMY2 = 12;
const byte NUM_TILES_SMALL = 4;
const byte NUM_SQUAREMETAL = 4;
const byte NUM_TILEMETAL = 4;
const byte NUM_SQUARERASTER = 4;

byte SquareMetal[6] = { 16, 64, 16, 4, 4, 4 };
byte TileMetal[6] = { 16+64, 64, 16, 4, 4, 5 };
byte SquareRaster[6] = { 16+64+64, 64, 16, 4, 4, 6 };
byte* TileDB[3] = {SquareMetal, TileMetal, SquareRaster};

word PlayerSprites[NUM_PLAYER];
word Enemy2Sprites[NUM_ENEMY2];

// Addressed used for graphics in main banked memory.
const dword BANK_PLAYER = 0x02000;
const dword BANK_ENEMY2 = 0x04000;
const dword BANK_TILES_SMALL = 0x14000;
const dword BANK_SQUAREMETAL = 0x16000;
const dword BANK_TILEMETAL = 0x22000;
const dword BANK_SQUARERASTER = 0x28000;
const dword BANK_PALETTE = 0x34000;

// Addresses used to store graphics in VERA VRAM.
const dword VRAM_PLAYER = 0x00000; 
const dword VRAM_ENEMY2 = 0x01800; 
const dword VRAM_TILES_SMALL = 0x03000; 
const dword VRAM_SQUAREMETAL = 0x03800; 
const dword VRAM_TILEMETAL = 0x05800; 
const dword VRAM_SQUARERASTER = 0x07800; 

const dword VRAM_TILEMAP = 0x10000;

// Sprite attributes: 4bpp, in front, 32x32, address SPRITE_PIXELS_VRAM
struct VERA_SPRITE SPRITE_ATTR = { <(VRAM_PLAYER/32)|VERA_SPRITE_4BPP, 320-32, 240-32, 0x0c, VERA_SPRITE_WIDTH_32 | VERA_SPRITE_HEIGHT_32 | 0x1 };

const char FILE_SPRITES[] = "PLAYER";
const char FILE_ENEMY2[] = "ENEMY2";
const char FILE_TILES[] = "TILES";
const char FILE_TILEMETAL[] = "TILEMETAL";
const char FILE_SQUARERASTER[] = "SQUARERASTER";
const char FILE_SQUAREMETAL[] = "SQUAREMETAL";
const char FILE_PALETTES[] = "PALETTES";

volatile byte i = 0;
volatile byte j = 0;
volatile byte a = 4;
volatile word vscroll = 0;
volatile word scroll_action = 2;

void vera_tile_element( byte layer, byte x, byte y, byte resolution, byte* Tile ) {

    byte TileOffset = Tile[0];
    byte TileTotal = Tile[1];
    byte TileCount = Tile[2];
    byte TileRows = Tile[3];
    byte TileColumns = Tile[4]; 
    byte PaletteOffset = Tile[5];

    x = x << resolution;
    y = y << resolution;

    dword mapbase = vera_mapbase_address[layer];
    byte shift = vera_layer_rowshift[layer];
    word rowskip = (word)1 << shift;
    mapbase += ((word)y << shift);
    mapbase += (x << 1);

    for(byte j=0;j<TileTotal;j+=(TileTotal>>1)) {
        for(byte i=0;i<TileCount;i+=(TileColumns)) {
            vera_vram_address0(mapbase,VERA_INC_1);
            for(byte r=0;r<(TileTotal>>1);r+=TileCount) {
                for(byte c=0;c<TileColumns;c+=1) {
                    *VERA_DATA0 = TileOffset+c+r+i+j;
                    *VERA_DATA0 = PaletteOffset << 4;
                }
            }
            mapbase += rowskip;
        }
    }
}

void rotate_sprites(word base, word rotate, word max, word *spriteaddresses, word basex, word basey) {
    for(byte s=0;s<max;s++) {
        word i = s+rotate;
        if(i>=max) i-=max;
        SPRITE_ATTR.ADDR = spriteaddresses[i];
        SPRITE_ATTR.X = basex+((word)(s&03)<<6);
        SPRITE_ATTR.Y = basey+((word)(s>>2)<<6);
        // Copy sprite positions to VRAM (the 4 relevant bytes in VERA_SPRITE_ATTR)
        vera_sprite_attributes_set((byte)(s+base),SPRITE_ATTR);
    }

}

//VSYNC Interrupt Routine
__interrupt(rom_sys_cx16) void irq_vsync() {
    // Move the sprite around

    a--;
    if(a==0) {
        a=4;

        rotate_sprites(0, i,NUM_PLAYER,PlayerSprites,40,100);
        rotate_sprites(16, j,NUM_ENEMY2,Enemy2Sprites,340,100);

        i++;
        if(i>=NUM_PLAYER) i=0;
        j++;
        if(j>=NUM_ENEMY2) j=0;

    }

    if(scroll_action--) {
        scroll_action = 2;
        vscroll++;
        if(vscroll>(64)*2-1) {
            memcpy_in_vram(1, <VRAM_TILEMAP, VERA_INC_1, 1, (<VRAM_TILEMAP)+64*16, VERA_INC_1, 64*16*4);
            for(byte r=4;r<5;r+=1) {
                for(byte c=0;c<5;c+=1) {
                    byte rnd = (byte)modr16u(rand(),3,0);
                    vera_tile_element( 0, c, r, 3, TileDB[rnd]);
                }
            }
            vscroll=0;
        } 
        vera_layer_set_vertical_scroll(0,vscroll);
    }

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
}

void create_sprites_player() {

    // Copy sprite palette to VRAM
    // Copy 8* sprite attributes to VRAM    
    word PLAYER_SPRITE_OFFSET = <(VRAM_PLAYER/32)|VERA_SPRITE_4BPP;
    for(char s=0;s<NUM_PLAYER;s++) {
        word x = ((word)(s&03)<<6);
        word y = ((word)(s>>2)<<6);
        PlayerSprites[s] = PLAYER_SPRITE_OFFSET;
        SPRITE_ATTR.ADDR = PLAYER_SPRITE_OFFSET;
        SPRITE_ATTR.X = 40+x;
        SPRITE_ATTR.Y = 100+y;
        SPRITE_ATTR.CTRL2 = VERA_SPRITE_WIDTH_32 | VERA_SPRITE_HEIGHT_32 | 0x1;
        vera_sprite_attributes_set(s,SPRITE_ATTR);
        PLAYER_SPRITE_OFFSET += 16;
    }
}

void create_sprites_enemy2() {

    word ENEMY2_SPRITE_OFFSET = <(VRAM_ENEMY2/32)|VERA_SPRITE_4BPP;
    for(char s=0;s<NUM_ENEMY2;s++) {
        word x = ((word)(s&03)<<6);
        word y = ((word)(s>>2)<<6);
        Enemy2Sprites[s] = ENEMY2_SPRITE_OFFSET;
        SPRITE_ATTR.ADDR = ENEMY2_SPRITE_OFFSET;
        SPRITE_ATTR.X = 340+x;
        SPRITE_ATTR.Y = 100+y;
        SPRITE_ATTR.CTRL2 = VERA_SPRITE_WIDTH_32 | VERA_SPRITE_HEIGHT_32 | 0x2;
        vera_sprite_attributes_set(s+16,SPRITE_ATTR);
        ENEMY2_SPRITE_OFFSET += 16;
    }
}



void tile_background() {
    for(byte r=0;r<6;r+=1) {
        for(byte c=0;c<5;c+=1) {
            byte rnd = (byte)modr16u(rand(),3,0);
            vera_tile_element( 0, c, r, 3, TileDB[rnd]);
        }
    }
}




void main() {

    VIA1->PORT_B = 0;

    memcpy_in_vram(1, 0xF000, VERA_INC_1, 0, 0xF800, VERA_INC_1, 256*8); // We copy the 128 character set of 8 bytes each.
    vera_layer_mode_tile(1, (dword)0x1A000, (dword)0x1F000, 128, 64, 8, 8, 1);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();

    // Now we activate the tile mode.
    vera_layer_mode_tile(0, (dword)VRAM_TILEMAP, VRAM_TILES_SMALL, 64, 64, 16, 16, 4);

    // Loading the graphics in main banked memory.
    char status = cx16_load_ram_banked(1, 8, 0, FILE_SPRITES, (dword)BANK_PLAYER);
    if(status!=$ff) printf("error file_sprites: %x\n",status);
    status = cx16_load_ram_banked(1, 8, 0, FILE_ENEMY2, (dword)BANK_ENEMY2);
    if(status!=$ff) printf("error file_enemy2 = %x\n",status);
    status = cx16_load_ram_banked(1, 8, 0, FILE_TILES, (dword)BANK_TILES_SMALL);
    if(status!=$ff) printf("error file_tiles = %x\n",status);
    status = cx16_load_ram_banked(1, 8, 0, FILE_SQUAREMETAL, (dword)BANK_SQUAREMETAL);
    if(status!=$ff) printf("error file_squaremetal = %x\n",status);
    status = cx16_load_ram_banked(1, 8, 0, FILE_TILEMETAL, (dword)BANK_TILEMETAL);
    if(status!=$ff) printf("error file_tilemetal = %x\n",status);
    status = cx16_load_ram_banked(1, 8, 0, FILE_SQUARERASTER, (dword)BANK_SQUARERASTER);
    if(status!=$ff) printf("error file_squareraster = %x\n",status);
    
    // Load the palette in main banked memory.
    status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, (dword)BANK_PALETTE);
    if(status!=$ff) printf("error file_palettes = %u",status);


    // Copy graphics to the VERA VRAM.
    bnkcpy_vram_address(VRAM_PLAYER, BANK_PLAYER, (dword)32*32*NUM_PLAYER/2);
    bnkcpy_vram_address(VRAM_ENEMY2, BANK_ENEMY2, (dword)32*32*NUM_ENEMY2/2);
    bnkcpy_vram_address(VRAM_TILES_SMALL, BANK_TILES_SMALL, (dword)32*32*(NUM_TILES_SMALL)/2);
    bnkcpy_vram_address(VRAM_SQUAREMETAL, BANK_SQUAREMETAL, (dword)64*64*(NUM_SQUAREMETAL)/2);
    bnkcpy_vram_address(VRAM_TILEMETAL, BANK_TILEMETAL, (dword)64*64*(NUM_TILEMETAL)/2);
    bnkcpy_vram_address(VRAM_SQUARERASTER, BANK_SQUARERASTER, (dword)64*64*(NUM_SQUARERASTER)/2);

    // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    bnkcpy_vram_address(VERA_PALETTE+32, BANK_PALETTE, (dword)32*6);

    vera_layer_show(0);

    tile_background();

    create_sprites_player();
    create_sprites_enemy2();

    // Enable sprites
    *VERA_CTRL &= ~VERA_DCSEL;
    *VERA_DC_VIDEO |= VERA_SPRITES_ENABLE;


    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC; 
    CLI();

    while(!fgetc());

    VIA1->PORT_B = 4;
}


/*
#pragma data_seg(Palettes)
export char *PALETTES;


#pragma data_seg(Player)
export char BITMAP_SHIP1[] = kickasm(resource "Ship_1/ship_1.png") {{{
    .var palette = Hashtable()
    .var palList = List()
    .var nxt_idx = 0;
    .for(var p=1;p<=NUM_PLAYER;p++) {
        .var pic = LoadPicture("Ship_1/ship_" + p + ".png")
        .for (var y=0; y<32; y++) {
            .for (var x=0;x<32; x++) {
                // Find palette index (add if not known)
                .var rgb = pic.getPixel(x,y);
                .var idx = palette.get(rgb)
                .if(idx==null) {
                    .eval idx = nxt_idx++;
                    .eval palette.put(rgb,idx);
                    .eval palList.add(rgb)
                }
            }
        }
    }
    .if(nxt_idx>16) .error "Image has too many colours "+nxt_idx
    
    .segment Palettes    
    .for(var i=0;i<16;i++) {
        .var rgb = 0
        .if(i<palList.size())
            .eval rgb = palList.get(i)
        .var red = ceil(rgb / [256*256])
        .var green = ceil(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
    }

    .segment Player
    .for(var p=1;p<=NUM_PLAYER;p++) {
        .var pic = LoadPicture("Ship_1/ship_" + p + ".png")
        .for (var y=0; y<32; y++) {
            .for (var x=0;x<32; x+=2) {
                // Find palette index (add if not known)
                .var rgb = pic.getPixel(x,y);
                .var idx1 = palette.get(rgb)
                .if(idx1==null) {
                    .printnow "unknown rgb value!"
                }
                // Find palette index (add if not known)
                .eval rgb = pic.getPixel(x+1,y);
                .var idx2 = palette.get(rgb)
                .if(idx2==null) {
                    .printnow "unknown rgb value!"
                }
                .byte idx1*16+idx2;
            }
        }
    }
};}};

#pragma data_seg(Enemy2)
export char BITMAP_ENEMY2[] = kickasm(resource "Enemy_2/Enemy_1.png") {{{
    
    .var nxt_idx = 0;
    .var palList = List();
    .var palette = Hashtable();
    .for(var p=1;p<=NUM_ENEMY2;p++) {
        .var pic = LoadPicture("Enemy_2/Enemy_" + p + ".png")
        .for (var y=0; y<32; y++) {
            .for (var x=0;x<32; x++) {
                // Find palette index (add if not known)
                .var rgb = pic.getPixel(x,y);
                .var idx = palette.get(rgb);
                .if(idx==null) {
                    .eval idx = nxt_idx++;
                    .eval palette.put(rgb,idx);
                    .eval palList.add(rgb);
                }
            }
        }
    }
    .printnow "colors = " + nxt_idx
    .if(nxt_idx>16) .error "Image has too many colours "+nxt_idx
    
    .segment Palettes    
    .for(var i=0;i<16;i++) {
        .var rgb = 0
        .if(i<palList.size())
            .eval rgb = palList.get(i)
        .var red = ceil(rgb / [256*256])
        .var green = ceil(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
    }

    .segment Enemy2
    .for(var p=1;p<=NUM_ENEMY2;p++) {
        .var pic = LoadPicture("Enemy_2/Enemy_" + p + ".png")
        .for (var y=0; y<32; y++) {
            .for (var x=0;x<32; x+=2) {
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
                .byte idx1*16+idx2;
            }
        }
    }
};}};

#pragma data_seg(SquareMetal)
export char TILE_PIXELS_SMALL[] = kickasm(resource "Floor/SmallMetal_1.png") {{{
    .var palette = Hashtable()
    .var palList = List()
    .var nxt_idx = 0;
    .for(var p=1;p<=NUM_TILES_SMALL;p++) {
        .var pic = LoadPicture("Floor/SmallMetal_" + p + ".png")
        .for (var y=0; y<32; y++) {
            .for (var x=0;x<32; x++) {
                // Find palette index (add if not known)
                .var rgb = pic.getPixel(x,y);
                .var idx = palette.get(rgb)
                .if(idx==null) {
                    .eval idx = nxt_idx++;
                    .eval palette.put(rgb,idx);
                    .eval palList.add(rgb)
                }
            }
        }
    }
    .if(nxt_idx>16) .error "Image has too many colours "+nxt_idx
    
    .segment Palettes    
    .for(var i=0;i<16;i++) {
        .var rgb = 16*256*256+16*256+16
        .if(i<palList.size())
            .eval rgb = palList.get(i)
        .var red = ceil(rgb / [256*256])
        .var green = ceil(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
        .printnow "tile small: rgb = " + rgb + ", i = " + i
    }

    .segment TileS
    .for(var p=1;p<=NUM_TILES_SMALL;p++) {
        .var pic = LoadPicture("Floor/SmallMetal_" + p + ".png")
        .for(var j=0; j<32; j+=16) {
            .for(var i=0; i<32; i+=16) {
                .for (var y=j; y<j+16; y++) {
                    .for (var x=i; x<i+16; x+=2) {
                        // .printnow "j="+j+",y="+y+",i="+i+",x="+x
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
                        .byte idx1*16+idx2;
                    }
                }
            }
        }
    }
};}};

#pragma data_seg(SquareMetal)
export char BITMAP_SQUAREMETAL[] = kickasm(resource "Floor/SquareMetal_1.png") {{{
    .var palette = Hashtable()
    .var palList = List()
    .var nxt_idx = 0;
    .for(var p=1;p<=NUM_SQUAREMETAL;p++) {
        .var pic = LoadPicture("Floor/SquareMetal_" + p + ".png")
        .for (var y=0; y<64; y++) {
            .for (var x=0;x<64; x++) {
                // Find palette index (add if not known)
                .var rgb = pic.getPixel(x,y);
                .var idx = palette.get(rgb)
                .if(idx==null) {
                    .eval idx = nxt_idx++;
                    .eval palette.put(rgb,idx);
                    .eval palList.add(rgb)
                }
            }
        }
    }
    .if(nxt_idx>16) .error "Image has too many colours "+nxt_idx

    .segment Palettes    
    .for(var i=0;i<16;i++) {
        .var rgb = 0
        .if(i<palList.size())
            .eval rgb = palList.get(i)
        .var red = ceil(rgb / [256*256])
        .var green = ceil(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
        // .printnow "tile large: rgb = " + rgb + ", i = " + i
    }

    .segment SquareMetal
    .for(var p=1;p<=NUM_SQUAREMETAL;p++) {
        .var pic = LoadPicture("Floor/SquareMetal_" + p + ".png")
        .for(var j=0; j<64; j+=16) {
            .for(var i=0; i<64; i+=16) {
                .for (var y=j; y<j+16; y++) {
                    .for (var x=i; x<i+16; x+=2) {
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
                        .byte idx1*16+idx2;
                    }
                }
            }
        }
    }
};}};

#pragma data_seg(TileMetal)
export char BITMAP_TILEMETAL[] = kickasm(resource "Floor/TileMetal_1.png") {{{
    .var palette = Hashtable()
    .var palList = List()
    .var nxt_idx = 0;
    .for(var p=1;p<=NUM_TILEMETAL;p++) {
        .var pic = LoadPicture("Floor/TileMetal_" + p + ".png")
        .for (var y=0; y<64; y++) {
            .for (var x=0;x<64; x++) {
                // Find palette index (add if not known)
                .var rgb = pic.getPixel(x,y);
                .var idx = palette.get(rgb)
                .if(idx==null) {
                    .eval idx = nxt_idx++;
                    .eval palette.put(rgb,idx);
                    .eval palList.add(rgb)
                }
            }
        }
    }
    .if(nxt_idx>16) .error "Image has too many colours "+nxt_idx

    .segment Palettes    
    .for(var i=0;i<16;i++) {
        .var rgb = 0
        .if(i<palList.size())
            .eval rgb = palList.get(i)
        .var red = ceil(rgb / [256*256])
        .var green = ceil(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
        // .printnow "tile large: rgb = " + rgb + ", i = " + i
    }

    .segment TileMetal
    .for(var p=1;p<=NUM_TILEMETAL;p++) {
        .var pic = LoadPicture("Floor/TileMetal_" + p + ".png")
        .for(var j=0; j<64; j+=16) {
            .for(var i=0; i<64; i+=16) {
                .for (var y=j; y<j+16; y++) {
                    .for (var x=i; x<i+16; x+=2) {
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
                        .byte idx1*16+idx2;
                    }
                }
            }
        }
    }
};}};

#pragma data_seg(SquareRaster)
export char BITMAP_SQUARERASTER[] = kickasm(resource "Floor/SquareRaster_1.png") {{{
    .var palette = Hashtable()
    .var palList = List()
    .var nxt_idx = 0;
    .for(var p=1;p<=NUM_TILEMETAL;p++) {
        .var pic = LoadPicture("Floor/SquareRaster_" + p + ".png")
        .for (var y=0; y<64; y++) {
            .for (var x=0;x<64; x++) {
                // Find palette index (add if not known)
                .var rgb = pic.getPixel(x,y);
                .var idx = palette.get(rgb)
                .if(idx==null) {
                    .eval idx = nxt_idx++;
                    .eval palette.put(rgb,idx);
                    .eval palList.add(rgb)
                }
            }
        }
    }
    .if(nxt_idx>16) .error "Image has too many colours "+nxt_idx

    .segment Palettes    
    .for(var i=0;i<16;i++) {
        .var rgb = 0
        .if(i<palList.size())
            .eval rgb = palList.get(i)
        .var red = ceil(rgb / [256*256])
        .var green = ceil(rgb/256) & 255
        .var blue = rgb & 255
        // bits 4-8: green, bits 0-3 blue
        .byte green&$f0  | blue/16
        // bits bits 0-3 red
        .byte red/16
        // .printnow "tile large: rgb = " + rgb + ", i = " + i
    }

    .segment SquareRaster
    .for(var p=1;p<=NUM_TILEMETAL;p++) {
        .var pic = LoadPicture("Floor/SquareRaster_" + p + ".png")
        .for(var j=0; j<64; j+=16) {
            .for(var i=0; i<64; i+=16) {
                .for (var y=j; y<j+16; y++) {
                    .for (var x=i; x<i+16; x+=2) {
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
                        .byte idx1*16+idx2;
                    }
                }
            }
        }
    }
};}};
*/

// #pragma data_seg(Data)
