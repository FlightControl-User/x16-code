#pragma link("equinoxe-lib.ld")

#pragma var_model(mem)

#pragma lib_configure
#pragma calling(__varcall)
#pragma lib_export(stage_get_flightpath_action)
#pragma lib_export(stage_get_flightpath_type)
#pragma lib_export(stage_get_flightpath_next)
#pragma lib_export(stage_get_flightpath_action_move_flight)
#pragma lib_export(stage_get_flightpath_action_move_turn)
#pragma lib_export(stage_get_flightpath_action_move_speed)
#pragma lib_export(stage_get_flightpath_action_turn_turn)
#pragma lib_export(stage_get_flightpath_action_turn_radius)
#pragma lib_export(stage_get_flightpath_action_move_speed)
#pragma lib_export(stage_get_flightpath_action_turn_speed)
#pragma lib_export(stage_player_remove)
#pragma lib_export(stage_enemy_remove)
#pragma lib_export(stage_bullet_add)
#pragma lib_export(stage_bullet_remove)
#pragma lib_export(stage_tower_remove)
#pragma lib_export(stage_impact)
#pragma calling(__phicall)

#include "equinoxe-defines.h"
#include "equinoxe-types.h"
#include "equinoxe-stage-flight.h"
#include "equinoxe-levels.h"
#include <equinoxe-flightengine.p>
#include <equinoxe-waves.p>
#include <equinoxe-bullet.p>
// #include <lib_conio.p>


#pragma data_seg(DATA_ENGINE_STAGES)
__lib_export stage_t stage;

#ifdef __BANKING
#pragma code_seg(CODE_ENGINE_STAGES)
#pragma data_seg(DATA_ENGINE_STAGES)
#pragma bank(cx16_ram,BANK_ENGINE_STAGES)
#endif

void stage_player_remove(flight_index_t p) {
#ifdef __PLAYER
    flight_index_t n = flight.engine[p];
    flight_remove(FLIGHT_ENGINE, n);
    flight_remove(FLIGHT_PLAYER, p);
    stage.player_respawn = 8;       // Wait 8 ticks until stage respawns the sprite. This needs rework. TODO.
    stage.player_count--;
#endif
}

void stage_enemy_remove(wave_index_t w, flight_index_t e)
{
#ifdef __ENEMY
    wave.enemy_spawn[w] += 1;
    wave.enemy_alive[w] -= 1;
    flight_remove(FLIGHT_ENEMY, e);
    stage.enemy_count--;
#endif
}

void stage_tower_remove(flight_index_t t)
{
    flight_remove(FLIGHT_TOWER, t);
    stage.tower_count--;
}

void stage_bullet_add(unsigned int sx, unsigned int sy, unsigned int tx, unsigned int ty, unsigned char speed, flight_side_t side, sprite_index_t sprite_bullet) {
#ifdef __BULLET
    bullet_add(sx, sy, tx, ty, speed, side, sprite_bullet);
    stage.bullet_count++;
#endif
}

void stage_bullet_remove(flight_index_t b) {
#ifdef __BULLET
    flight_remove(FLIGHT_BULLET, b);
    stage.bullet_count--;
#endif
}

void stage_impact(flight_index_t f, flight_index_t h)
{
    unsigned char hit = flight_hit(f, flight_impact(h));
    if(hit) {
        switch(flight.type[f]) {
#ifdef __ENEMY
            case FLIGHT_ENEMY:
                stage_enemy_remove(flight_wave(f), f);
                break;
#endif
#ifdef __BULLET
            case FLIGHT_BULLET:
                stage_bullet_remove(f);
                break;
#endif
            case FLIGHT_PLAYER:
                stage_player_remove(f);
                break;
            case FLIGHT_TOWER:
                stage_tower_remove(f);
                break;
        }                
    }
}


stage_action_t* stage_get_flightpath_action(stage_flightpath_t* flightpath, unsigned char action) {
    stage_action_t* flightpath_action = &flightpath[action].action;
    return flightpath_action;
}

unsigned char stage_get_flightpath_type(stage_flightpath_t* flightpath, unsigned char action) {
    unsigned char type = flightpath[action].type;
    return type;
}

unsigned char stage_get_flightpath_next(stage_flightpath_t* flightpath, unsigned char action) {
    unsigned char next = flightpath[action].next;
    return next;
}


unsigned int stage_get_flightpath_action_move_flight(stage_action_t* action_move) {
    return ((stage_action_move_t*)action_move)->flight;
}

signed char stage_get_flightpath_action_move_turn(stage_action_t* action_move) {
    return ((stage_action_move_t*)action_move)->turn;
}

unsigned char stage_get_flightpath_action_move_speed(stage_action_t* action_move) {
    return ((stage_action_move_t*)action_move)->speed;
}


signed char stage_get_flightpath_action_turn_turn(volatile stage_action_t* action_turn) {
    return ((stage_action_turn_t*)action_turn)->turn;
}

unsigned char stage_get_flightpath_action_turn_radius(stage_action_t* action_turn) {
    return ((stage_action_turn_t*)action_turn)->radius;
}

unsigned char stage_get_flightpath_action_turn_speed(stage_action_t* action_turn) {
    return ((stage_action_turn_t*)action_turn)->speed;
}



#pragma data_seg(Data)
#pragma code_seg(Code)

#pragma nobank


