/**
 * @file equinoxe-defines.h
 * @author Sven Van de Velde (sven.van.de.velde@telenet.be)
 * @brief Defines to control compilation and includes.
 * @version 0.1
 * @date 2022-10-03
 * 
 * @copyright Copyright (c) 2022
 * 
 */

#include "equinoxe-bank.h"

// #define __CONIO_BSOUT
// #define __LAYER1
// #define __NOVSYNC
#define __CPULINES

#define __PALETTE

#define __FLIGHT
#define __STAGE
#define __COLLISION


#define __FLOOR
// #define __TOWER
#define __PLAYER
#define __BULLET
#define __ENEMY
#define __ENGINE

#define __BANKING

// Sprite cache to avoid loading the same sprites over and over from bram.
// #define __DEBUG_SPRITE_CACHE

// #define __DEBUG_LRU_CACHE

// #define __VERAHEAP_DUMP
// #define __VERAHEAP_DEBUG
// #define __VERAHEAP_COLOR_FREE


// Show information when generating the floor.
// #define __DEBUG_FLOOR

// Show heap allocation and free processes.
// #define __DEBUG_HEAP_BRAM_BLOCKED

// Show the table before the game starts, with the loaded objects in the heap!
// #define __DEBUG_HEAP_BRAM

// Shows info while loading the game assets.
// #define __DEBUG_LOAD

// Shows detailed debug info when loading the files.
// #define __DEBUG_FILE

// Includes printf statements, we need to ignore those which are not necessary, because it takes a lot of compile time.
// #define __INCLUDE_PRINT

// Shows a table outlining the palette usage.
// #define __DEBUG_PALETTE

// Show a table with the wave cache information evolving.
// #define __DEBUG_WAVE

// Show stage information when the scenario changes and is active.
// #define __DEBUG_STAGE

// Show lru cache information when the objects are flying.
// #define __DEBUG_LRU_CACHE

// Show the collision hash table while the game is evolving.
// #define __DEBUG_COLLISION
// #define __DEBUG_COLLISION_HASH

// #define __DEBUG_ENGINE


#define BREAKPOINT   {asm{.byte $db}}
