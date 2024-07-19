
#define __VERA_LAYER1



// todo to move into vera memory addressing define
#define FLOOR_TILE_BANK_VRAM        0x00
#define FLOOR_TILE_OFFSET_VRAM      0x0000

#define SPRITE_BANK_VRAM            0x00
#define SPRITE_OFFSET_VRAM          0x5000

#ifdef __VERA_LAYER1
#define FLOOR_MAP1_BANK_VRAM        0x01
#define FLOOR_MAP1_OFFSET_VRAM      0xE000
#define FLOOR_MAP0_BANK_VRAM        0x01
#define FLOOR_MAP0_OFFSET_VRAM      0xD000
#else
#define FLOOR_MAP1_BANK_VRAM        0x01
#define FLOOR_MAP1_OFFSET_VRAM      0xB000
#define FLOOR_MAP0_BANK_VRAM        0x00
#define FLOOR_MAP0_OFFSET_VRAM      0x0000
#endif

