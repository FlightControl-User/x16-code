#pragma var_model(local_ssa_mem)

#include <cx16.h>
#include <cx16-veralib.h>
#include <cx16-heap.h>
#include <kernal.h>
#include <6502.h>
#include <conio.h>
#include <cx16-conio.h>
#include <printf.h>
#include <stdio.h>
#include <division.h>
#include <mos6522.h>
#include <multiply.h>

struct sprite {
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
    heap_handle BRAM_Handle;
    heap_handle VRAM_Handle[16];
};


byte const SPRITE_PLAYER01_COUNT = 7;
struct sprite sprite =       { "PLAYER01", SPRITE_PLAYER01_COUNT, 0, 32*32*SPRITE_PLAYER01_COUNT/2, 512, 32, 32, 3, 0, 0, 4, 1, 0x0, { 0x0 } };





int main() {

    // We are going to use only the kernal on the X16.
    bank_set_brom(CX16_ROM_KERNAL);

    // Handle the relocation of the CX16 petscii character set and map to the most upper corner in VERA VRAM.
    petscii();

    vera_sprites_show();

    gotoxy(0, 10);

    unsigned int status = load_bram(1, 8, 0, sprite->File, 1, 0xA000);
    if(status!=$ff) printf("error file %s: %x\n", sprite->File, status);

    byte SpriteCount = sprite->SpriteCount;
    word SpriteSize = sprite->SpriteSize;
    byte SpriteOffset = sprite->SpriteOffset;

    byte bank_vram_sprite = 0;
    word ptr_vram_sprite = 0x0000;
    byte bank_bram_sprite = 1;
    byte* ptr_bram_sprite = 0xA000;

    for(byte s=0;s<SpriteCount;s++) {

        printf("bram->vram: %x, bank_vram_sprite = %x, ptr_vram_sprite = %p, bank_bram_sprite = %x, ptr_bram_sprite = %p, SpriteSize = %x\n", s, bank_vram_sprite, ptr_vram_sprite, bank_bram_sprite, ptr_bram_sprite, SpriteSize);
        memcpy_vram_bram(bank_vram_sprite, (word)ptr_vram_sprite, bank_vram_sprite, (byte*)ptr_bram_sprite, SpriteSize);

        vera_sprite_bpp(s+1, sprite->BPP);
        vera_sprite_height(s+1, sprite->Height);
        vera_sprite_width(s+1, sprite->Width);
        vera_sprite_hflip(s+1, sprite->Hflip);
        vera_sprite_vflip(s+1, sprite->Vflip);
        vera_sprite_palette_offset(s+1, sprite->PaletteOffset);
        vera_sprite_xy(s+1, s*36, 20);
        vera_sprite_zdepth(s+1, sprite->Zdepth);

        vera_sprite_ptr(s+1, 0, 0x0000);

        ptr_bram_sprite = bank_bram_ptr_inc(bank_bram_sprite, ptr_bram_sprite, SpriteSize);
        bank_bram_sprite = bank_get_bram();
        while(!getin());
    }

    sprite->BRAM_Handle = handle_bram_sprite;
    
    while(!getin());

    // Back to basic.
    bank_set_brom(CX16_ROM_BASIC);


}