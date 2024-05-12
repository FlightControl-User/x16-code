
#include "equinoxe-flightengine-types.h"
#include "equinoxe-stage-types.h"

#define WAVE_COUNT 8

typedef struct {
    unsigned char enemy_count[WAVE_COUNT]; // Temporary that holds the total amount of enemies in a scenario.
    unsigned char enemy_spawn[WAVE_COUNT]; // Temporary that holds the amount of enemies that can be spawned at the same time.
    sprite_index_t enemy_sprite[WAVE_COUNT]; // Temporary that holds the sprite of the enemy to be spawned.
    stage_flightpath_t* enemy_flightpath[WAVE_COUNT]; // Temporary that holds the flight path of the enemy to be followed.
    unsigned char enemy_alive[WAVE_COUNT];
    signed int x[WAVE_COUNT];
    signed int y[WAVE_COUNT];
    signed char dx[WAVE_COUNT];
    signed char dy[WAVE_COUNT];
    unsigned char interval[WAVE_COUNT];
    unsigned char wait[WAVE_COUNT];
    unsigned char prev[WAVE_COUNT];
    unsigned char used[WAVE_COUNT];
    unsigned char finished[WAVE_COUNT];
    unsigned int scenario[WAVE_COUNT];
    unsigned char animation_speed[WAVE_COUNT];
    unsigned char animation_reverse[WAVE_COUNT];
} wave_t;

typedef unsigned char wave_index_t;

