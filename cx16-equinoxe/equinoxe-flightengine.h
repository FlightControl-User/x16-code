#ifndef equinoxe_flightengine_h
#define equinoxe_flightengine_h

#include <cx16-heap.h>
#include <cx16-vera.h>
#include <cx16-veralib.h>
#include <fp3.h>
#include <ht.h>

typedef struct _sprite {
    char File[16];
    unsigned char SpriteCount;
    unsigned char SpriteOffset;
    unsigned int TotalSize;
    unsigned int SpriteSize;
    unsigned char Height;
    unsigned char Width;
    unsigned char Zdepth;
    unsigned char Hflip;
    unsigned char Vflip;
    unsigned char BPP;
    unsigned char PaletteOffset; 
    heap_handle BRAM_Handle;
    vera_sprite_image_offset offset_image[16];
} Sprite;


#define SPRITE_PLAYER01_COUNT 7
Sprite SpritePlayer01 =       { 
    "PLAYER01", 
    SPRITE_PLAYER01_COUNT, 
    0, 32*32*SPRITE_PLAYER01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 9, 0x0, { 0x0 } 
};

#define SPRITE_ENEMY01_COUNT 12
Sprite SpriteEnemy01 =       { 
    "ENEMY01", SPRITE_ENEMY01_COUNT, 
    7, 32*32*SPRITE_ENEMY01_COUNT/2, 512, 
    VERA_SPRITE_HEIGHT_32, VERA_SPRITE_WIDTH_32, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 10, 0x0, { 0x0 } 
};

#define SPRITE_ENGINE01_COUNT 16
Sprite SpriteEngine01 =       { 
    "ENGINE01", SPRITE_ENGINE01_COUNT, 
    7+12, 16*16*SPRITE_ENGINE01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 11, 0x0, { 0x0 } 
};

#define SPRITE_BULLET01_COUNT 1
Sprite SpriteBullet01 =       { 
    "BULLET01", SPRITE_BULLET01_COUNT, 
    7+12+16, 16*16*SPRITE_BULLET01_COUNT/2, 128, 
    VERA_SPRITE_HEIGHT_16, VERA_SPRITE_WIDTH_16, 
    VERA_SPRITE_ZDEPTH_IN_FRONT, 
    VERA_SPRITE_NFLIP, VERA_SPRITE_NFLIP, 
    VERA_SPRITE_4BPP, 12, 0x0, { 0x0 } };

byte const SPRITE_TYPES = 4;
byte const SPRITE_PLAYER01 = 0;
byte const SPRITE_ENEMY01 = 1;
byte const SPRITE_ENGINE01 = 2;
byte const SPRITE_BULLET01 = 3;
__mem Sprite *SpriteDB[4] = { &SpritePlayer01, &SpriteEnemy01, &SpriteEngine01, &SpriteBullet01 };


// Work variables

byte const SPRITE_COUNT = SPRITE_PLAYER01_COUNT + SPRITE_ENEMY01_COUNT + SPRITE_ENGINE01_COUNT + SPRITE_BULLET01_COUNT; 

typedef struct collision_s {
    unsigned char cells;
    ht_item_t* cell[4];
} collision_t;


typedef struct entity_s {
    heap_handle next;
    heap_handle prev;
    signed int x;
    signed int y;
    signed char fx;
    signed char fy;
    signed char dx;
    signed char dy;
    byte active;
    byte SpriteType;
    byte state_behaviour;
    byte state_animation;
    byte wait_animation;
    byte speed_animation;
    byte health;
    byte gun;
    byte strength;
    byte reload;
    byte moved;
    byte side;
    byte firegun;
    unsigned int flight;
    unsigned char move;
    unsigned char step;
    unsigned char angle;
    unsigned char baseangle;
    unsigned char radius;
    unsigned char delay;
    signed char turn;
    unsigned char speed;
    unsigned char enabled;
    Sprite* sprite_type;
    vera_sprite_offset sprite_offset;

    heap_handle engine_handle;
    FP3 tx;
    FP3 ty;
    FP3 tdx;
    FP3 tdy;

    collision_t grid;

    unsigned char xmask;
    unsigned char ymask;
} entity_t;

void Logic();
// void Draw();


void sprite_create(Sprite* sprite, vera_sprite_offset sprite_offset);
void sprite_animate(vera_sprite_offset sprite_offset, Sprite* sprite, byte index, byte animate);
void sprite_position(vera_sprite_offset sprite_offset, vera_sprite_coordinate x, vera_sprite_coordinate y);
void sprite_configure(vera_sprite_offset sprite_offset, Sprite* sprite);
void sprite_enable(vera_sprite_offset sprite_offset, Sprite* sprite);
void sprite_disable(vera_sprite_offset sprite_offset);

#endif