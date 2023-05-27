
#include "equinoxe.h"

#pragma data_seg(DATA_ENGINE_STAGES)

volatile stage_wave_t wave;
volatile stage_t stage;


#ifdef __BANKING
#pragma code_seg(CODE_ENGINE_STAGES)
#pragma data_seg(DATA_ENGINE_STAGES)
#pragma bank(cx16_ram,BANK_ENGINE_STAGES)
#endif


inline stage_playbook_t* stage_playbook_ptr() {
    stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b;
    return &stage_playbooks_b[stage.playbook_current];
}

/// @brief Retrieve the pointer to the scenario element.
/// @param stage_playbook_ptr_b The playbook where the scenario resides.
/// @param scenario The sequence number of the scenario.
/// @return The scenario pointer.
inline stage_scenario_t* stage_scenario_ptr(stage_playbook_t* stage_playbook_ptr_b, stage_scenario_index_t scenario) {
    stage_scenario_t* stage_scenarios_b = stage_playbook_ptr_b->scenarios_b;
    return &stage_scenarios_b[scenario];
}

void stage_copy(unsigned char ew, stage_scenario_index_t scenario) {

    stage_playbook_t* stage_playbook_ptr_b = stage_playbook_ptr();
    stage_scenario_t* stage_scenario_ptr_b = stage_scenario_ptr(stage_playbook_ptr_b, scenario);

    wave.x[ew] = stage_scenario_ptr_b->x;
    wave.y[ew] = stage_scenario_ptr_b->y;

    wave.enemy_count[ew] = stage_scenario_ptr_b->enemy_count;

    wave.dx[ew] = stage_scenario_ptr_b->dx;
    wave.dy[ew] = stage_scenario_ptr_b->dy;

    wave.enemy_flightpath[ew] = stage_scenario_ptr_b->enemy_flightpath;
    wave.enemy_spawn[ew] = stage_scenario_ptr_b->enemy_spawn;

    stage_enemy_t* stage_enemy = stage_scenario_ptr_b->stage_enemy;
    wave.animation_speed[ew] = stage_enemy->animation_speed;
    wave.animation_reverse[ew] = stage_enemy->animation_reverse;

    wave.enemy_sprite[ew] = stage_enemy->enemy_sprite_flight;
    wave.interval[ew] = stage_scenario_ptr_b->interval;
    wave.prev[ew] = stage_scenario_ptr_b->prev;
    wave.wait[ew] = stage_scenario_ptr_b->wait;
    wave.used[ew] = 1;
    wave.finished[ew] = 0;
    wave.scenario[ew] = scenario;

    wave.enemy_alive[ew] = 0;

}


void stage_load_player(stage_player_t* stage_player)
{
    // Loading the player sprites in bram.
    sprite_index_t player_sprite = stage_player->player_sprite;
        
    stage.sprite_offset = fe_sprite_bram_load(player_sprite, stage.sprite_offset);
        
    stage_engine_t* stage_engine = stage_player->stage_engine;
    sprite_index_t engine_sprite = stage_engine->engine_sprite;
    stage.sprite_offset = fe_sprite_bram_load(engine_sprite, stage.sprite_offset);

    stage_bullet_t* stage_bullet = stage_player->stage_bullet;
    sprite_index_t bullet_sprite = stage_bullet->bullet_sprite;
    stage.sprite_offset = fe_sprite_bram_load(bullet_sprite, stage.sprite_offset);
}


void stage_load_enemy(stage_enemy_t* stage_enemy)
{
    // Loading the enemy sprites in bram.
    sprite_index_t enemy_sprite = stage_enemy->enemy_sprite_flight;
    
    stage.sprite_offset = fe_sprite_bram_load(enemy_sprite, stage.sprite_offset);
        
    stage_bullet_t* stage_bullet = stage_enemy->stage_bullet;
    sprite_index_t bullet_sprite = stage_bullet->bullet_sprite;
    stage.sprite_offset = fe_sprite_bram_load(bullet_sprite, stage.sprite_offset);
        
        // stage_engine_t* stage_engine = &stage_enemy->stage_engine;
        // sprite_index_t engine_sprite = stage_engine->engine_sprite;
        // if(!engine_sprite->loaded) {
        //     stage.sprite_offset = fe_sprite_bram_load(engine_sprite, stage.sprite_offset);
        // }
}

#ifdef __FLOOR
void stage_load_floor(stage_floor_t* stage_floor)
{
    // Loading the floor in bram.

    stage_floor_bram_tiles_t* floor_bram_tiles = stage_floor->floor_bram_tiles;
    floor_t* floor = stage_floor->floor;

    floor_part_memset_vram(0, floor, 0);

    volatile unsigned char part=1;
    for(unsigned char f=0; f<stage_floor->floor_file_count; f++) {
        floor_bram_tiles_t* floor_bram = floor_bram_tiles[f].floor_bram_tile;
        part = floor_parts_load_bram(part, floor, floor_bram);
    }
    unsigned char parts_count = part-1;

    for(unsigned char part=1; part<=parts_count; part++) {
        floor_part_memcpy_vram_bram(part, floor);
    }

    floor_layer_index_segments(floor);
    floor_layer_map(floor, 0, FLOOR_MAP0_BANK_VRAM, FLOOR_MAP0_OFFSET_VRAM);
    #ifdef __LAYER1
    floor_layer_map(floor, 1, FLOOR_MAP1_BANK_VRAM, FLOOR_MAP1_OFFSET_VRAM);
    #endif
    // floor_layer_debug(floor, 0);
    // floor_layer_debug(floor, 1);

    stage.floor = floor;
}
#endif

#ifdef __TOWER
void stage_load_tower(stage_tower_t* stage_tower)
{

    // Loading the floor in bram.

    stage_floor_bram_tiles_t* tower_bram_tiles = stage_tower->tower_bram_tiles;
    floor_t* towers = stage_tower->towers;
    sprite_index_t tower_sprite = stage_tower->turret;

    floor_part_memset_vram(0, towers, 0); // Set the transparency tile for the towers.

    // Now count from 1!
    unsigned char part=1;
    for(unsigned char t=0; t<stage_tower->tower_file_count; t++) {
        floor_bram_tiles_t* tower_bram = tower_bram_tiles[t].floor_bram_tile;
        part = floor_parts_load_bram(part, towers, tower_bram);
    }
    unsigned char parts_count = part-1;

    for(unsigned char part=1; part<=parts_count; part++) {
        floor_part_memcpy_vram_bram(part, towers);
    }

    stage.sprite_offset = fe_sprite_bram_load(tower_sprite, stage.sprite_offset);

    stage_bullet_t* stage_bullet = stage_tower->stage_bullet;
    sprite_index_t bullet_sprite = stage_bullet->bullet_sprite;
    stage.sprite_offset = fe_sprite_bram_load(bullet_sprite, stage.sprite_offset);

    stage.towers = towers;

}

stage_tower_t* stage_tower_get()
{
    stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b;
    stage_playbook_t* stage_playbook_b = &stage_playbooks_b[stage.playbook_current];
    stage_tower_t* stage_towers = stage_playbook_b->stage_towers;
    return stage_towers;
}
#endif

static void stage_load(void)
{
    stage_playbook_t* stage_playbooks_b = stage.script_b.playbooks_b;
    stage_playbook_t* stage_playbook_b = &stage_playbooks_b[stage.playbook_current];
    stage_scenario_t* stage_scenarios_b = stage_playbook_b->scenarios_b;
    unsigned int stage_scenario_total = stage_playbook_b->scenario_total_b;

#ifdef __FLOOR
    stage_load_floor(stage_playbook_b->stage_floor);
#endif


#ifdef __TOWER
    // Loading towers tiles and towers sprites in bram.
    unsigned char tower_count = stage_playbook_b->tower_count;
    for(unsigned char t=0; t<tower_count; t++) {
        stage_load_tower(stage_playbook_b->stage_towers);
    }
#endif


#ifdef __PLAYER
    stage_load_player(stage_playbook_b->stage_player);
#endif


#if defined(__ENEMY)
    // Loading the enemy sprites in bram.
    for(unsigned int scenario = 0; scenario < stage_scenario_total; scenario++) {
        stage_scenario_t* stage_scenario = &stage_scenarios_b[scenario];
        stage_load_enemy(stage_scenario->stage_enemy);
    }
#endif


}


static void stage_reset(void)
{

#ifdef __PALETTE
    palette_init(BANK_ENGINE_PALETTE);
#endif

#ifdef __PLAYER
    player_init();
#endif

#ifdef __BULLET
    bullet_init();
#endif

#ifdef __ENEMY
    enemy_init();
#endif


	memset(&stage, 0, sizeof(stage_t));

    stage.script_b.playbook_total_b = 1;
    stage.script_b.playbooks_b = stage_playbooks_b;

    // stage.current_playbook = stage_playbook[stage.playbook];
    memcpy(&stage.current_playbook, &stage_playbooks_b[stage.playbook_current], sizeof(stage_playbook_t));

    stage.lives = 10;
    stage.scenario_total = stage.current_playbook.scenario_total_b; // bug?

    stage_load(); // Load the artefacts of the stage.

    stage_copy(stage.ew, stage.scenario_current); // Copy the stage.scenario into the stage wave cache.

#ifdef __PLAYER
    // Add the player to the stage.
    stage_player_t* stage_player = stage_playbooks_b->stage_player;
    stage_engine_t* stage_engine = stage_player->stage_engine;
	player_add(stage_player->player_sprite, stage_engine->engine_sprite);
#endif
}

void stage_player_add(sprite_index_t sprite_player, sprite_index_t sprite_engine) {
#ifdef __PLAYER
    player_add(sprite_player, sprite_engine);
    stage.player_count++;
#endif
}

void stage_player_remove(flight_index_t p) {
#ifdef __PLAYER
    player_remove(p);
    stage.player_count--;
#endif
}

void stage_tower_add(unsigned char column, unsigned char row) {
#ifdef __TOWER
    stage_tower_t* st = stage.current_playbook.stage_towers;
    sprite_index_t turret = st->turret;
    unsigned char tx = st->turret_x;
    unsigned char ty = st->turret_y;
    unsigned char fx = st->fire_x;
    unsigned char fy = st->fire_y;
    tower_add(turret, (unsigned int)column*64+tx, (unsigned int)ty-64-(game.screen_vscroll % 16), fx, fy);
    stage.tower_count++;
#endif
}

void stage_tower_remove(unsigned char t)
{
#ifdef __TOWER
    tower_remove(t);
    stage.tower_count--;
#endif
}

void stage_enemy_add(unsigned char w, sprite_index_t enemy_sprite)
{
#ifdef __ENEMY
    unsigned char enemies = enemy_add(w, enemy_sprite);

    wave.x[w] += wave.dx[w];
    wave.y[w] += wave.dy[w];
    wave.wait[w] = wave.interval[w];
    wave.enemy_spawn[w] -= enemies;
    wave.enemy_count[w] -= enemies;
    wave.enemy_alive[w] += 1;
    stage.enemy_count++;
#endif
}


void stage_enemy_remove(unsigned char e)
{
#ifdef __ENEMY
    unsigned char w = enemy_get_wave(e);
    wave.enemy_spawn[w] += 1;
    wave.enemy_alive[w] -= 1;
    enemy_remove(e);
    stage.enemy_count--;
#endif
}


void stage_impact(unsigned char f, flight_index_t h)
{
    signed char hit = flight_hit(f, flight_impact(h));
    if(hit) {
        switch(flight.type[f]) {
#ifdef __ENEMY
            case FLIGHT_ENEMY:
                stage_enemy_remove(f);
                break;
#endif
            case FLIGHT_BULLET:
                stage_bullet_remove(f);
                break;
            case FLIGHT_PLAYER:
                stage_player_remove(f);
                break;
            case FLIGHT_TOWER:
                stage_tower_remove(f);
                break;
        }                
    }
}

void stage_bullet_add(unsigned int sx, unsigned int sy, unsigned int tx, unsigned int ty, unsigned char speed, flight_side_t side, sprite_index_t sprite_bullet) {
#ifdef __BULLET
    bullet_add(sx, sy, tx, ty, speed, side, sprite_bullet);
    stage.bullet_count++;
#endif
}

void stage_bullet_remove(flight_index_t b) {
#ifdef __BULLET
    bullet_remove(b);
    stage.bullet_count--;
#endif
}

void stage_logic()
{
    if(stage.playbook_current < stage.script_b.playbook_total_b) {
        
        if(!(game.tickstage & 0x03)) {

            floor_evolve();
#ifdef __DEBUG_STAGE
#endif
            // BREAKPOINT
            for(__mem unsigned char w=0; w<8; w++) {
                if(wave.used[w]) {
                    if(!wave.wait[w]) {
                        if(wave.enemy_count[w]) {
                            if(wave.enemy_spawn[w]) {
                                #ifdef __ENEMY
                                stage_enemy_add(w, wave.enemy_sprite[w]);
                                #endif
                            }
                        } else {
                            if(!wave.enemy_alive[w]) {
                                wave.used[w] = 0;
                                wave.finished[w] = 1;
                            }
                        }
                    } else {
                       wave.wait[w]--;
                    }
                }
#ifdef __DEBUG_WAVE
                gotoxy(0,50+w);
                printf("wave %02x  %02x  %02x  %02x  %02x  %02x  %04p  %02x", w, wave.used[w], wave.wait[w], wave.enemy_count[w], wave.enemy_spawn[w], wave.finished[w], wave.enemy_sprite[w], wave.scenario[w]);
#endif
            }

            for(unsigned char w=0; w<8; w++) {

                // Check if a wave has finished.
                if(wave.finished[w]) {

                    // If there are more scenarios, create new waves based on the scenarios dependent on the finished wave.
                    __mem stage_scenario_index_t new_scenario = wave.scenario[w];
                    __mem unsigned int wave_scenario = wave.scenario[w];
                    // TODO find solution for this loop, maybe with pointers?
                    while(new_scenario < stage.scenario_total) {
                        stage_playbook_t* stage_playbook_ptr_b = stage_playbook_ptr();
                        stage_scenario_t* stage_scenario_ptr_b = stage_scenario_ptr(stage_playbook_ptr_b, new_scenario); 

                        unsigned int prev = stage_scenario_ptr_b->prev;

                        if(prev == wave_scenario) {
                            // We create new waves from the scenarios that are dependent on the finished one.
                            // There must always be at least one that equals scenario of the previous scenario.
                            stage.ew = (stage.ew+1) & 0x07;
                            stage_copy(stage.ew, new_scenario);
                        }
                        new_scenario++;
                    }
                    wave.finished[w] = 0;
                    // stage.scenario_current = new_scenario;
                }
            }

            if(stage.scenario_current >= stage.scenario_total) {
                if(stage.playbook_current < stage.script_b.playbook_total_b) {
                    // stage.playbook_current++;
                    // stage_playbook_t* stage_playbook = stage.script_b.playbooks_b;
                    // stage.current_playbook = stage_playbook[stage.playbook_current];
                    // stage.scenario_total = stage.current_playbook.scenario_total_b;
                    stage.scenario_current = 0;
                }
            }
        }
    }

    if(stage.player_respawn) {
        stage.player_respawn--;
        if(!stage.player_respawn) {
#ifdef __PLAYER
            stage_playbook_t* stage_playbook_ptr_b = stage_playbook_ptr();
            stage_player_t* stage_player_ptr_b = stage_playbook_ptr_b->stage_player;
            stage_engine_t* stage_engine_ptr_b = stage_player_ptr_b->stage_engine;
            player_add(stage_player_ptr_b->player_sprite, stage_engine_ptr_b->engine_sprite);
#endif
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



void stage_display()
{
    gotoxy(0,0);
    printf("stage statistics\n");
    printf("count bullets=%04u, enemies=%04u, towers=%04u, players:%04u\n", stage.bullet_count, stage.enemy_count, stage.tower_count, stage.player_count);
}

#pragma data_seg(Data)
#pragma code_seg(Code)

#pragma nobank


