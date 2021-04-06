
struct Sprite {
    char File[16];
    byte SpriteCount;
    byte SpriteOffset;
    word TotalSize;
    word SpriteSize;
    byte Height;
    byte Width;
    byte Zdepth;
    byte Hflip;
    byte Vflip;
    byte BPP;
    byte PaletteOffset; 
    dword BRAM_Address;
    dword VRAM_Address[12];
};



byte const SPRITE_PLAYER01_01_COUNT = 7;
struct Sprite SpritePlayer01 =       { "PLAYER01", SPRITE_PLAYER01_01_COUNT, 0, 32*32*SPRITE_PLAYER01_01_COUNT/2, 512, 32, 32, 1, 0, 0, 4, 1, 0x0, { 0x0 } };


byte const SPRITE_TYPES = 1;
__mem struct Sprite *SpriteDB[1] = { &SpritePlayer01 };


// Work variables

byte const SPRITE_COUNT = SPRITE_PLAYER01_01_COUNT; 

byte const HEAP_SPRITES = 0;

