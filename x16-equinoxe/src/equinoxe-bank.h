#pragma once
 
    // VERA Memory is managed as follows:
    // ------------------------------------------------------------------------
    //
    // SEGMENT                          VRAM                  BRAM
    // -------------------------        -----------------     -----------------
    // FLOOR MAP                        00:0000 - 00:2000     
    // FLOOR TILE                       00:2000 - 00:A000
    // SPRITES                          00:A000 - 01:B000
    // PETSCII                          01:B000 - 01:F800     


// Main memory layout
// ------------------

//      SEGMENTS                     LINKER SEGMENT ID      BANK  START   END     PURPOSE
//      ---------------------------  ---------------------  ----  ------  ------  -------
//   
//           SPRITE_CACHE                                   0x00  0x9000  0x9F00  Contains the sprite cache to blazingly fast track sprite movements.
#define DATA_SPRITE_CACHE            DataSpriteCache
//
//           VERA_HEAP                                                       0xA000  0xBFFF  Contains the index of the dynamic heap data of the objects in the vera.                                                         
#define BANK_VERA_HEAP                                      0x01
#define DATA_VERA_HEAP               CodeVeraHeap
#define CODE_VERA_HEAP               CodeVeraHeap
#define BRAM_VERA_HEAP               BramVeraHeap
//
//           FLIGHT_ENGINE                                                   0xA000  0xBFFF  Flight engine.                                                         
#define BANK_ENGINE_FLIGHT                                  0x02
#define BANK_ENGINE_TOWERS                                  0x02
#define CODE_ENGINE_FLIGHT           CodeEngineFlight
#define DATA_ENGINE_FLIGHT           DataEngineFlight
#define BRAM_ENGINE_FLIGHT           BramEngineFlight
//
#define BANK_ENGINE_STAGES                                  0x03
#define CODE_ENGINE_STAGES           CodeEngineStages
#define DATA_ENGINE_STAGES           DataEngineStages
#define BRAM_ENGINE_STAGES           BramEngineStages
//
#define BANK_ENGINE_SPRITES                                 0x04
//
#define BANK_ENGINE_FLOOR                                   0x05
#define CODE_ENGINE_FLOOR            CodeEngineFloor
#define DATA_ENGINE_FLOOR            DataEngineFloor
#define BRAM_ENGINE_FLOOR            BramEngineFloor
//
#define BANK_ENGINE_PALETTE                                 0x06
#define CODE_ENGINE_PALETTE          CodeEnginePalette
#define DATA_ENGINE_PALETTE          DataEnginePalette
#define BRAM_ENGINE_PALETTE          BramEnginePalette
//
#define BANK_ENGINE_BULLETS                                 0x07
#define CODE_ENGINE_BULLETS          CodeEngineBullets
//
#define BANK_ENGINE_ENEMIES                                 0x08
#define CODE_ENGINE_ENEMIES          CodeEngineEnemies
#define DATA_ENGINE_ENEMIES          DataEngineEnemies
//
#define BANK_ENGINE_PLAYERS                                 0x02
#define CODE_ENGINE_PLAYERS          CodeEnginePlayers
#define DATA_ENGINE_PLAYERS          DataEnginePlayers
//
#define BANK_HEAP_BRAM                                      0x0F


// todo to move into vera memory addressing define
#define FLOOR_MAP0_BANK_VRAM        0x00
#define FLOOR_MAP0_OFFSET_VRAM      0x0000

#define FLOOR_MAP1_BANK_VRAM        0x01
#define FLOOR_MAP1_OFFSET_VRAM      0xB000

#define FLOOR_TILE_BANK_VRAM        0x00
#define FLOOR_TILE_OFFSET_VRAM      0x2000

#define SPRITE_BANK_VRAM            0x00
#define SPRITE_OFFSET_VRAM          0x4000
