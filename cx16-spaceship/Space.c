// Example program for the Commander X16

#pragma link("space.ld")

#pragma zp_reserve(0x01, 0x02, 0x80..0xA8)

#pragma data_seg(Data)

#include <cx16.h>
#include <cx16-veralib.h>
#include <cx16-veramem.h>
#include <kernal.h>
#include <6502.h>
#include <conio.h>
#include <printf.h>
#include <stdio.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>


struct Sprite {
    char File[16];
    byte Offset;
    byte SpriteCount;
    word TotalSize;
    word SpriteSize;
    byte Width;
    byte Height;
    byte Hflip;
    byte Vflip;
    byte Zdepth;
    byte BPP;
    byte Palette;
    dword BRAM_Address;
    dword VRAM_Addresses[12];
};

byte const SPRITE_PLAYER = 0;
byte const SPRITE_ENEMY2 = 1;

__mem struct Sprite SpritesPlayer = {"PLAYER",     0,  12, 32*32*12/2, 512, 32, 32, 0, 1, 3, 4, 1, 0x0, {0}};
__mem struct Sprite SpritesEnemy2 = {"ENEMY2",    12,  12, 32*32*12/2, 512, 32, 32, 0, 0, 3, 4, 2, 0x0, {0}};
__mem struct Sprite *SpriteDB[2];


struct Tile {
    char File[16];
    word Offset;
    byte TileCount;
    word TotalSize;
    word TileSize;
    byte DrawTotal;
    byte DrawCount;
    byte DrawRows;
    byte DrawColumns;
    byte Palette; 
    dword BRAM_Address;
    dword VRAM_Addresses[12];
};

byte const TILE_SQUAREMETAL = 0;
byte const TILE_TILEMETAL = 1;
byte const TILE_SQUARERASTER = 2;

__mem struct Tile SquareMetal =  { "SQUAREMETAL",     0, 4, 64*64*4/2, 2048, 64, 16, 4, 4, 4, 0x0, {0}};
__mem struct Tile TileMetal =    { "TILEMETAL",      64, 4, 64*64*4/2, 2048, 64, 16, 4, 4, 5, 0x0, {0}};
__mem struct Tile SquareRaster = { "SQUARERASTER",  128, 4, 64*64*4/2, 2048, 64, 16, 4, 4, 6, 0x0, {0}};
// TODO: BUG! This is not compiling correctly! __mem struct Tile *TileDB[3] = {&SquareMetal, &TileMetal, &SquareRaster};
__mem struct Tile *TileDB[3];

byte const HEAP_VRAM_SPRITES = 0;
byte const HEAP_SEGMENT_VRAM_FLOOR_MAP = 1;
byte const HEAP_SEGMENT_VRAM_FLOOR_TILE = 2;
byte const HEAP_SEGMENT_VRAM_PETSCII = 3;

const dword VRAM_PETSCII_MAP = 0x1B000;
const dword VRAM_PETSCII_TILE = 0x1F000;

__mem dword bram_sprites_base;
__mem dword bram_sprites_ceil;
__mem dword bram_tiles_base;
__mem dword bram_tiles_ceil;
__mem dword bram_palette;

volatile dword vram_floor_map;

const char FILE_PALETTES[] = "PALETTES";



void vera_tile_element( byte layer, byte x, byte y, byte resolution, struct Tile* Tile ) {

    word TileOffset = Tile->Offset;
    byte TileTotal = Tile->DrawTotal;
    byte TileCount = Tile->DrawCount;
    byte TileRows = Tile->DrawRows;
    byte TileColumns = Tile->DrawColumns; 
    byte PaletteOffset = Tile->Palette;

    x = x << resolution;
    y = y << resolution;

    dword mapbase = vera_mapbase_address[layer];
    byte shift = vera_layer_rowshift[layer];
    word rowskip = (word)1 << shift;
    mapbase += ((word)y << shift);
    mapbase += (x << 1);

    for(byte j=0;j<TileTotal;j+=(TileTotal>>1)) {
        for(byte i=0;i<TileCount;i+=(TileColumns)) {
            vera_vram_data0_address(mapbase,VERA_INC_1);
            for(byte r=0;r<(TileTotal>>1);r+=TileCount) {
                for(byte c=0;c<TileColumns;c+=1) {
                    *VERA_DATA0 = (<TileOffset)+c+r+i+j;
                    *VERA_DATA0 = PaletteOffset << 4 | (>TileOffset);
                }
            }
            mapbase += rowskip;
        }
    }
}

void rotate_sprites(word rotate, struct Sprite *Sprite, word basex, word basey) {
    byte offset = Sprite->Offset;
    word max = Sprite->SpriteCount;
    for(byte s=0;s<max;s++) {
        word i = s+rotate;
        if(i>=max) i-=max;
        vera_sprite_address(s+offset, Sprite->VRAM_Addresses[i]);
        vera_sprite_xy(s+offset, basex+((word)(s&03)<<6), basey+((word)(s>>2)<<6));
    }

}

__mem volatile byte i = 0;
__mem volatile byte j = 0;
__mem volatile byte a = 4;
__mem volatile word row = 5;
__mem volatile word vscroll = 128*5;
__mem volatile word scroll_action = 2;

//VSYNC Interrupt Routine
__interrupt(rom_sys_cx16) void irq_vsync() {
    // Move the sprite around

    a--;
    if(a==0) {
        a=4;

        rotate_sprites(i,  SpriteDB[SPRITE_PLAYER], 40, 100);
        rotate_sprites(j, SpriteDB[SPRITE_ENEMY2], 340, 100);

        i++;
        if(i>=12) i=0;
        j++;
        if(j>=12) j=0;

    }

    if(scroll_action--) {
        scroll_action = 10;
        if((<vscroll & 0x80)==<vscroll) {
            if(row<=4) {
                dword dest_row = vram_floor_map+((row+4)*8*64*2);
                dword src_row = vram_floor_map+(row*8*64*2);
                vera_cpy_vram_vram(src_row, dest_row, (dword)64*8*2);
                gotoxy(0, 21);
                printf("src_row:%x dest_row:%x vram_floor_map:%x   ",src_row, dest_row, vram_floor_map);
            }
            if(vscroll==0) {
                vscroll=128*4;
                row = 4;
            }
            for(byte c=0;c<5;c++) {
                byte rnd = (byte)modr16u(rand(),3,0);
                vera_tile_element( 0, c, (byte)row-1, 3, TileDB[rnd]);
            }
            row--;
        } 
        vscroll--;
        vera_layer_set_vertical_scroll(0,vscroll);
    }

    gotoxy(0, 20);
    printf("vscroll:%u row:%u     ",vscroll, row);

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
}

void create_sprite(byte sprite) {

    // Copy sprite palette to VRAM
    // Copy 8* sprite attributes to VRAM
    struct Sprite *Sprite = SpriteDB[sprite];
    for(byte s=0;s<Sprite->SpriteCount;s++) {
        byte Offset = Sprite->Offset+s;
        vera_sprite_bpp(Offset, Sprite->BPP);
        vera_sprite_address(Offset, Sprite->VRAM_Addresses[s]);
        vera_sprite_xy(Offset, 40+((word)(s&03)<<6), 100+((word)(s>>2)<<6));
        vera_sprite_height(Offset, Sprite->Height);
        vera_sprite_width(Offset, Sprite->Width);
        vera_sprite_zdepth(Offset, Sprite->Zdepth);
        vera_sprite_hflip(Offset, Sprite->Hflip);
        vera_sprite_vflip(Offset, Sprite->Vflip);
        vera_sprite_palette_offset(Offset, Sprite->Palette);
    }
}



void tile_background() {
    for(byte r=5;r<10;r+=1) {
        for(byte c=0;c<5;c+=1) {
            byte rnd = (byte)modr16u(rand(),3,0);
            vera_tile_element( 0, c, r, 3, TileDB[rnd]);
        }
    }
}

void show_memory_map() {
    for(byte i=0;i<2;i++) {
        struct Sprite *Sprite = SpriteDB[i];
        gotoxy(0, 1+i);
        printf("s:%u bram:%x, vram:", i, Sprite->BRAM_Address);
        for(byte j=0;j<12;j++) {
            printf("%x ", Sprite->VRAM_Addresses[j]);
        }
    }
    for(byte i=0;i<3;i++) {
        struct Tile *Tile = TileDB[i];
        gotoxy(0, 4+i);
        printf("t:%u bram:%x, vram:", i, Tile->BRAM_Address);
        for(byte j=0;j<4;j++) {
            printf("%x ", Tile->VRAM_Addresses[j]);
        }
    }
}

void sprite_cpy_vram(byte segmentid, struct Sprite *Sprite) {
    dword bsrc = Sprite->BRAM_Address;
    byte num = Sprite->SpriteCount;
    word size = Sprite->SpriteSize;
    for(byte s=0;s<Sprite->SpriteCount;s++) {
        byte Offset = Sprite->Offset + s;
        dword vaddr = vera_heap_malloc(segmentid, size);
        dword baddr = bsrc+mul16u((word)s,size);
        vera_cpy_bank_vram(baddr, vaddr, size);
        Sprite->VRAM_Addresses[s] = vaddr;
    }
}

void tile_cpy_vram(byte segmentid, struct Tile *Tile) {
    dword bsrc = Tile->BRAM_Address;
    byte num = Tile->TileCount;
    word size = Tile->TileSize;
    for(byte s=0;s<num;s++) {
        dword vaddr = vera_heap_malloc(segmentid, size);
        dword baddr = bsrc+mul16u((word)s,size);
        vera_cpy_bank_vram(baddr, vaddr, size);
        Tile->VRAM_Addresses[s] = vaddr;
    }
}

dword load_sprite( struct Sprite *Sprite, dword bram_address) {
    char status = cx16_load_ram_banked(1, 8, 0, Sprite->File, bram_address);
    if(status!=$ff) printf("error file %s: %x\n", Sprite->File, status);
    Sprite->BRAM_Address = bram_address;
    word size = Sprite->TotalSize;
    return bram_address + size;
    // return bram_address + Sprite->Size; // TODO: fragment
}

dword load_tile( struct Tile *Tile, dword bram_address) {
    char status = cx16_load_ram_banked(1, 8, 0, Tile->File, bram_address);
    if(status!=$ff) printf("error file %s: %x\n", Tile->File, status);
    Tile->BRAM_Address = bram_address;
    word size = Tile->TotalSize;
    return bram_address + size;
    // return bram_address + Tile->Size; // TODO: fragment
}

void main() {

    TileDB[TILE_SQUAREMETAL] = &SquareMetal;
    TileDB[TILE_TILEMETAL] = &TileMetal;
    TileDB[TILE_SQUARERASTER] = &SquareRaster;

    SpriteDB[SPRITE_PLAYER] = &SpritesPlayer;
    SpriteDB[SPRITE_ENEMY2] = &SpritesEnemy2; 

    // Loading the graphics in main banked memory.
    bram_sprites_ceil = cx16_bram_user();
    bram_sprites_ceil = load_sprite(SpriteDB[SPRITE_PLAYER], bram_sprites_ceil);
    bram_sprites_ceil = load_sprite(SpriteDB[SPRITE_ENEMY2], bram_sprites_ceil);
    bram_tiles_ceil = bram_sprites_ceil;
    bram_tiles_ceil = load_tile(TileDB[TILE_SQUAREMETAL], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_TILEMETAL], bram_tiles_ceil);
    bram_tiles_ceil = load_tile(TileDB[TILE_SQUARERASTER], bram_tiles_ceil);

    // Load the palettes in main banked memory.
    bram_palette = bram_tiles_ceil;
    byte status = cx16_load_ram_banked(1, 8, 0, FILE_PALETTES, bram_palette);
    if(status!=$ff) printf("error file_palettes = %u",status);

    // We are going to use only the kernal on the X16.
    cx16_brom_bank_set(CX16_ROM_KERNAL);

    // Handle the relocation of the CX16 petscii character set and map to the most upper corner in VERA VRAM.
    // This frees up the maximum space in VERA VRAM available for graphics.
    const word VRAM_PETSCII_MAP_SIZE = 128*64*2;
    vera_heap_segment_init(HEAP_SEGMENT_VRAM_PETSCII, 0x1B000, VRAM_PETSCII_MAP_SIZE + VERA_PETSCII_TILE_SIZE);
    dword vram_petscii_map = vera_heap_malloc(HEAP_SEGMENT_VRAM_PETSCII, VRAM_PETSCII_MAP_SIZE);
    dword vram_petscii_tile = vera_heap_malloc(HEAP_SEGMENT_VRAM_PETSCII, VERA_PETSCII_TILE_SIZE);
    vera_cpy_vram_vram(VERA_PETSCII_TILE, VRAM_PETSCII_TILE, VERA_PETSCII_TILE_SIZE);
    vera_layer_mode_tile(1, vram_petscii_map, vram_petscii_tile, 128, 64, 8, 8, 1);

    screenlayer(1);
    textcolor(WHITE);
    bgcolor(BLACK);
    clrscr();


    const word VRAM_FLOOR_MAP_SIZE = 64*64*2;
    const word VRAM_FLOOR_TILE_SIZE = 12*64*64/2;
    __mem dword vram_segment_floor_map = vera_heap_segment_init(HEAP_SEGMENT_VRAM_FLOOR_MAP, vera_heap_segment_ceiling(HEAP_VRAM_SPRITES), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE);
    __mem dword vram_segment_floor_tile = vera_heap_segment_init(HEAP_SEGMENT_VRAM_FLOOR_TILE, vera_heap_segment_ceiling(HEAP_SEGMENT_VRAM_FLOOR_MAP), VRAM_FLOOR_MAP_SIZE+VRAM_FLOOR_TILE_SIZE);

    vram_floor_map = vram_segment_floor_map;

    // Now we activate the tile mode.
 
    sprite_cpy_vram(HEAP_VRAM_SPRITES, SpriteDB[SPRITE_PLAYER]);
    sprite_cpy_vram(HEAP_VRAM_SPRITES, SpriteDB[SPRITE_ENEMY2]);
    tile_cpy_vram(HEAP_SEGMENT_VRAM_FLOOR_TILE, TileDB[TILE_SQUAREMETAL]);
    tile_cpy_vram(HEAP_SEGMENT_VRAM_FLOOR_TILE, TileDB[TILE_TILEMETAL]);
    tile_cpy_vram(HEAP_SEGMENT_VRAM_FLOOR_TILE, TileDB[TILE_SQUARERASTER]);

    vera_layer_mode_tile(0, vram_segment_floor_map, vram_segment_floor_tile, 64, 64, 16, 16, 4);

    // Load the palette in VERA palette registers, but keep the first 16 colors untouched.
    vera_cpy_bank_vram(bram_palette, VERA_PALETTE+32, (dword)32*6);

    vera_layer_show(0);

    tile_background();

    create_sprite(SPRITE_PLAYER);
    create_sprite(SPRITE_ENEMY2);

    vera_sprite_on();

    show_memory_map();

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC; 
    CLI();

    while(!kbhit());

    // Back to basic.
    cx16_brom_bank_set(CX16_ROM_BASIC);
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
