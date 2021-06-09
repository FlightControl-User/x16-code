// Space tile scrolling engine for a space game written in kickc for the Commander X16.


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

#include "equinoxe.h"
#include "equinoxe-floorengine.h"

void vera_tile_clear( byte layer ) {

    byte PaletteOffset = 1;
    byte Offset = 100;

    dword mapbase = vera_mapbase_address[layer];

    printf("mapbase: %u, %x\n", layer, mapbase);

    vera_vram_address0(mapbase,VERA_INC_1);

    for(word i=0;i<64*20;i++) {
        *VERA_DATA0 = Offset;
        *VERA_DATA0 = PaletteOffset << 4;
    }
}


void vera_tile_element( byte layer, byte x, byte y, word Segment ) {

    gotoxy(4+x*4,y+12);
    printf("%02u ",Segment);

    byte resolution = 2;

    struct TileSegment *TileSegment = &(TileSegmentDB[Segment]);

    x = x << resolution;
    y = y << resolution;

    dword mapbase = vera_mapbase_address[layer];
    byte shift = vera_layer_rowshift[layer];
    word rowskip = (word)1 << shift;
    mapbase += ((word)y << shift);
    mapbase += (x << 1); // 2 bytes per tile (one index + one palette)

    for(byte sr=0;sr<4;sr+=2) {
        for(byte r=0;r<4;r+=2) {
            vera_vram_address0(mapbase,VERA_INC_1);
            for(byte sc=0;sc<2;sc++) {
                for(byte c=0;c<2;c++) {
                    byte s = sc + sr;
                    struct TilePart *TilePart = &TilePartDB[(word)TileSegment->Composition[s]];
                    struct Tile *Tile = TilePart->Tile; 
                    word TileOffset = (word)TileSegment->Composition[s];
                    TileOffset *= 4;
                    word Offset = TileOffset + c + r;
                    *VERA_DATA0 = <Offset;
                    *VERA_DATA0 = Tile->PaletteOffset << 4 | >Offset;
                }
            }
        mapbase += rowskip;
        }
    }
}



void floor_init(byte y, byte *TileFloorNew, byte *TileFloorOld) {

    printf("\no=%x, n=%x", (word)TileFloorOld, (word)TileFloorNew);

    byte rnd = (byte)modr16u(rand(),36,0);
    struct TileSegment *TileSegment = &(TileSegmentDB[(word)rnd]);
    TileFloorNew[0] = rnd;
    for(byte x=1;x<10;x++) {
        struct TileGlue *TileGlue = TileSegment->Glue[1];
        byte RndGlue = (byte)modr16u(rand(),TileGlue->CountGlue,0);
        byte GlueSegment = TileGlue->GlueSegment[RndGlue];
        TileSegment = &(TileSegmentDB[(word)GlueSegment]);
        TileFloorNew[x] = GlueSegment;
    }
    for(byte x=0;x<10;x++) {
        word Tile = (word)TileFloorNew[x];
        vera_tile_element( 0, x, y, Tile);
    }
}

struct TileGlue* floor_get_glue(byte GlueSegment, byte GlueDirection ) {
    struct TileSegment *TileSegment = &(TileSegmentDB[(word)GlueSegment]);
    struct TileGlue *TileGlue = TileSegment->Glue[GlueDirection];
    return TileGlue;
}

struct TileSegment* floor_get_random_gluesegment(struct TileGlue* TileGlue) {
    byte GlueSegment = TileGlue->GlueSegment[(byte)modr16u(rand(),TileGlue->CountGlue,0)];
    return GlueSegment;
}

void floor_draw(byte y, byte *TileFloorNew, byte *TileFloorOld) {

    byte TileResults[20];
    byte TileResultsWeighted[20];

    gotoxy(40,y+12);
    
    for(byte x=0;x<10;x++) {

        struct TileGlue *TileGlueNew;
        if(x>0) {
            // Start from the west side ...
            TileGlueNew = floor_get_glue(TileFloorNew[x-1], 1);
        } else {
            // Start from the south side ...
            TileGlueNew = floor_get_glue(TileFloorOld[0], 0);
        }

        // Find the common tile segment(s) ...
        byte TileResultCount = 0;
        for(byte i=0; i<TileGlueNew->CountGlue; i++) {
            byte GlueSegmentNew = TileGlueNew->GlueSegment[i];

            byte TileSouth = 0;
            byte TileEast = 0;
            if(x>0) {
                // Get the south side ...
                struct TileGlue *TileGlueSouth = floor_get_glue(TileFloorOld[x], 0);
                for(byte j=0;j<TileGlueSouth->CountGlue;j++) {
                    byte GlueSegmentSouth = TileGlueSouth->GlueSegment[j];
                    if( GlueSegmentNew == GlueSegmentSouth ) {
                        TileSouth = 1;
                    }
                }
            } else {
                TileSouth = 1;
            }
            if(x<9) {
                // Get the southeast side ...
                struct TileGlue *TileGlueSouthEast = floor_get_glue(TileFloorOld[x+1], 0);
                for(byte j=0;j<TileGlueSouthEast->CountGlue;j++) {
                    byte GlueSegmentSouthEast = TileGlueSouthEast->GlueSegment[j];
                    struct TileGlue *TileGlueEast = floor_get_glue(GlueSegmentSouthEast,3);
                    for(byte f=0;f<TileGlueEast->CountGlue;f++) {
                        byte GlueSegmentEast = TileGlueEast->GlueSegment[f];
                        // if(TileFloorOld[x+1]==9) {
                        //     printf("g%02u/g%02u/g%02u ", GlueSegmentNew, GlueSegmentEast, GlueSegmentSouthEast  );
                        // }
                        if( GlueSegmentNew == GlueSegmentEast ) {
                            TileEast = 1;
                        }
                    }
                }
            } else {
                TileEast = 1;
            }
            if(TileSouth == 1 && TileEast == 1) {
                TileResults[TileResultCount] = GlueSegmentNew;
                TileResultCount++;
            }
        }

        if( TileResultCount>0) {
            // First we check the maximum weight for the weighted selection in the list.
            byte MaxWeight = 0;
            byte MinWeight = 255;
            for(byte i=0;i<TileResultCount;i++) {
                byte Segment = TileResults[i];
                byte Weight = TileSegmentDB[(word)Segment].Weight; // TODO: this mandatory case needs to be reported.
                if( Weight > MaxWeight )
                    MaxWeight = Weight;
            }
            byte Weight = (byte)modr16u(rand(),(word)(MaxWeight),0);

            // Now build list with weighted selection ...
            byte TileResultsWeightedCount = 0;
            for(byte i=0;i<TileResultCount;i++) {
                byte Segment = TileResults[i];
                byte SegmentWeight = TileSegmentDB[(word)Segment].Weight;
                if( SegmentWeight >= Weight ) {
                    TileResultsWeighted[TileResultsWeightedCount] = Segment;
                    TileResultsWeightedCount++;
                }
            }
            if(TileResultsWeightedCount==0) printf("error");
            byte GlueSegment = TileResultsWeighted[(byte)modr16u(rand(),(word)(TileResultsWeightedCount),0)];
            TileFloorNew[x] = GlueSegment;
        } else {
            byte GlueSegment = 255;
            TileFloorNew[x] = GlueSegment;
        }
    }

    for(byte x=0;x<10;x++) {
        word Tile = (word)TileFloorNew[x];
        gotoxy(0,12+y); printf("y%02u",y);
        vera_tile_element( 0, x, y, Tile);
    }
}

void tile_background() {

    int TileIndex = 0;
    int TileIndexColumn = 0;
    int TileIndexRow = 0;
    TileIndex = TileIndexRow << 4 + TileIndexColumn;

    vera_tile_clear(0);
    byte y=15;
    floor_init(y, TileFloorNew, TileFloorOld);
    for( i=0;i<8;i++) {
        y--;
        floor_draw(y, s?TileFloorOld:TileFloorNew, s?TileFloorNew:TileFloorOld);
        s++;
        s&=1;
    }
    vera_layer_set_vertical_scroll(0,8*64);
   
}

void show_memory_map() {
    for(byte i=0;i<TILE_TYPES;i++) {
        struct Tile *Tile = TileDB[i];
        byte TileOffset = Tile->TileOffset;
        gotoxy(0, 30+i);
        printf("t:%u bram:%x:%p, vram:", i, heap_data_bank(Tile->BRAM_Handle), heap_data_ptr(Tile->BRAM_Handle));
        for(byte j=0;j<Tile->TileCount;j++) {
            struct TilePart *TilePart = &TilePartDB[(word)(TileOffset+j)];
            printf("%x:%p ", heap_data_bank(TilePart->VRAM_Handle), heap_data_ptr(TilePart->VRAM_Handle));
        }
    }
}

void tile_cpy_vram_from_bram(heap_segment segment_vram_tile, struct Tile *Tile) {

    heap_ptr ptr_bram_tile = heap_data_ptr(Tile->BRAM_Handle);
    heap_bank bank_bram_tile = heap_data_bank(Tile->BRAM_Handle);

    byte TileCount = Tile->TileCount;
    word TileSize = Tile->TileSize;
    byte TileOffset = Tile->TileOffset;

    for(byte t=0;t<TileCount;t++) {

        heap_handle handle_vram_tile = heap_alloc(segment_vram_tile, TileSize);
        heap_bank bank_vram_tile = heap_data_bank(handle_vram_tile);
        heap_ptr ptr_vram_tile = heap_data_ptr(handle_vram_tile);

        cx16_cpy_vram_from_bram(bank_vram_tile, (word)ptr_vram_tile, bank_bram_tile, (byte*)ptr_bram_tile, TileSize);

        struct TilePart *TilePart = &TilePartDB[(word)(TileOffset+t)];
        TilePart->VRAM_Handle = handle_vram_tile;
        ptr_bram_tile = cx16_bram_ptr_inc(bank_bram_tile, ptr_bram_tile, TileSize);
        bank_bram_tile = cx16_bram_bank_get();
    }
}


// Load the tile into bram using the new cx16 heap manager.
heap_handle tile_load( struct Tile *Tile, heap_segment segment_bram_tiles) {

    heap_handle handle_bram_tile = heap_alloc(segment_bram_tiles, Tile->TotalSize);  // Reserve enough memory on the heap for the tile loading.
    heap_ptr ptr_bram_tile = heap_data_ptr(handle_bram_tile);
    heap_bank bank_bram_tile = heap_data_bank(handle_bram_tile);
    heap_handle data_handle_bram_tile = heap_data_handle(handle_bram_tile);

    printf("bram: %x:%p\n", heap_data_bank(handle_bram_tile), heap_data_ptr(handle_bram_tile));

    char status = cx16_load_ram_banked(1, 8, 0, Tile->File, bank_bram_tile, ptr_bram_tile);
    if(status!=$ff) printf("error file %s: %x\n", Tile->File, status);

    Tile->BRAM_Handle = handle_bram_tile;
    while(!getin());
    return handle_bram_tile;
}

void main() {


    // We are going to use only the kernal on the X16.
    cx16_brom_bank_set(CX16_ROM_KERNAL);

    #include "equinoxe-petscii-move.c"

    // Allocate the segment for the tiles in vram.
    const word VRAM_FLOOR_MAP_SIZE = 64*64*2;
    const word VRAM_FLOOR_TILE_SIZE = TILE_FLOOR_COUNT*32*32/2;
    heap_segment segment_vram_floor_map = heap_segment_vram(HEAP_SEGMENT_VRAM_FLOOR_MAP, 1, 0x2000, 1, 0x0000, 1, 0xA400, 0);
    heap_segment segment_vram_floor_tile = heap_segment_vram(HEAP_SEGMENT_VRAM_FLOOR_TILE, 1, 0xA000, 1, 0x2000, 1, 0xA400, 0x100);

    #include "equinoxe-palettes.c"

    // Initialize the bram heap for tile loading.
    heap_segment segment_bram_floor_tile = heap_segment_bram(HEAP_SEGMENT_BRAM_TILES, 63, 0xC000, 33, 0xA000);

    gotoxy(0, 10);

    // Loading the graphics in main banked memory.
    for(i=0; i<TILE_TYPES;i++) {
        tile_load(TileDB[i], segment_bram_floor_tile);
    }

    // Now we activate the tile mode.
    for(i=0;i<TILE_TYPES;i++) {
        tile_cpy_vram_from_bram(segment_vram_floor_tile, TileDB[i]);
    }

    vram_floor_map_ulong = 0x10000;
    vera_layer_mode_tile(0, vram_floor_map_ulong, 0x12000, 64, 64, 16, 16, 4);

    show_memory_map();

    vera_layer_show(0);

    // floor_init();
    tile_background();

    // Enable VSYNC IRQ (also set line bit 8 to 0)
    SEI();
    *KERNEL_IRQ = &irq_vsync;
    *VERA_IEN = VERA_VSYNC; 
    CLI();

    while(!kbhit());

    // Back to basic.
    cx16_brom_bank_set(CX16_ROM_BASIC);
}

//VSYNC Interrupt Routine

__interrupt(rom_sys_cx16) void irq_vsync() {

    // background scrolling
    if(!scroll_action--) {
        scroll_action = 4;
        gotoxy(0, 10);
        printf("vscroll:%u row:%u   ",vscroll, row);
        if((<vscroll & 0xC0)==<vscroll ) {
            if(row<=7) {
                dword dest_row = vram_floor_map_ulong+((row+8)*4*64*2);
                dword src_row = vram_floor_map_ulong+(row*4*64*2);
                vera_cpy_vram_vram(src_row, dest_row, (dword)64*4*2);
            }
            if(vscroll==0) {
                vscroll=8*64;
                row = 8;
            }
            floor_draw((byte)row-1, s?TileFloorNew:TileFloorOld, s?TileFloorOld:TileFloorNew);
            s++;
            s&=1;
            row--;
        } 
        vera_layer_set_vertical_scroll(0,vscroll);
        vscroll--;
    }

    // Reset the VSYNC interrupt
    *VERA_ISR = VERA_VSYNC;
}
