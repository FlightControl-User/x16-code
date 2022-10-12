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

#define __MAIN

// #define __NOVSYNC

#define __CPULINES

#define __PALETTE

#define __FLOOR
#define __FLIGHT
#define __STAGE
#define __COLLISION

#define __PLAYER
#define __BULLET
#define __ENEMY
#define __ENGINE

// Sprite cache to avoid loading the same sprites over and over from bram.
// #define __DEBUG_SPRITE_CACHE

// #define __LRU_CACHE_DEBUG

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

// Shows a table outlining the palette usage.
// #define __DEBUG_PALETTE

// Show a table with the wave cache information evolving.
// #define __WAVE_DEBUG

// Show stage information when the scenario changes and is active.
// #define __DEBUG_STAGE

// #define __DEBUG_ENGINE


#define __VERAHEAP_SEGMENT
#define LRU_CACHE_MAX 64
