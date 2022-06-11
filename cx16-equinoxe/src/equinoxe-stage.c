#include <cx16.h>
#include <cx16-veralib.h>
#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-enemy.h"
#include "equinoxe-stage.h"
#include "equinoxe-palette.h"

#include "levels/equinoxe-levels.h"

#pragma data_seg(Data)

stage_t stage;

stage_wave_t wave[8];


void stage_init(bram_bank_t bram_bank)
{
	memset(&stage, 0, sizeof(stage_t));

    unsigned int bytes = load_file(1,8,0, "levels.bin", bram_bank, (bram_ptr_t) 0xA000);
    printf("level loaded, %x bytes\n", bytes);

}


vera_sprite_offset NextOffset(vera_sprite_id sprite_start, vera_sprite_id sprite_end, vera_sprite_id* sprite_id, unsigned char* count)
{
	while(sprite_offsets[*sprite_id]) {
		*sprite_id = ((*sprite_id) >= sprite_end)?sprite_start:(*sprite_id)+1;
	}

	(*count)++;
	vera_sprite_offset sprite_offset = vera_sprite_get_offset(*sprite_id); 
	sprite_offsets[*sprite_id] = sprite_offset;
	return sprite_offset;
}


void FreeOffset(vera_sprite_offset sprite_offset, unsigned char* count)
{
	vera_sprite_id sprite_id = vera_sprite_get_id(sprite_offset);
	sprite_offsets[sprite_id] = 0;
	(*count)--;
}


static void stage_reset(void)
{
    bank_push_bram(); bank_set_bram(BRAM_STAGE); // stage_scenario is at BRAM_STAGE

    enemy_init();

#ifdef __PLAYER
    player_init();
#endif

#ifdef __BULLET
    bullet_init();
#endif

	memset(&stage, 0, sizeof(stage_t));

	stage.sprite_bullet = SPRITE_OFFSET_BULLET_START;
	stage.sprite_bullet_count = 0;
	stage.sprite_enemy = SPRITE_OFFSET_ENEMY_START;
	stage.sprite_enemy_count = 0;
	stage.sprite_player = SPRITE_OFFSET_PLAYER_START;
	stage.sprite_player_count = 0;

    stage.script.playbooks = 1;
    stage.script.playbook = stage_playbook;

    stage.score = 0;
    stage.penalty = 0;
    stage.lives = 10;
    stage.respawn = 0;

    stage_playbook_t* stage_playbook = stage.script.playbook;
    stage_scenario_t* stage_scenario = stage_playbook[stage.playbook].scenario;

    memcpy(&wave[stage.ew], &stage_scenario[stage.scenario], sizeof(stage_scenario_t));
    wave[stage.ew].used = 1;
    wave[stage.ew].finished = 0;
    wave[stage.ew].scenario = 0;

    stage.playbook = 0;
    stage.scenario = 0;
    stage.scenarios = stage_playbook[stage.playbook].scenarios;

    printf("stage.scenarios = %u", stage.scenarios);

    bank_pull_bram();

#ifdef __PLAYER
    // Add the player to the stage.
	player_add();
#endif
}


inline void stage_enemy_add(unsigned char w, sprite_bram_t* sprite, stage_flightpath_t* flights)
{
    unsigned char enemies = AddEnemy(w, sprite, flights, wave[w].x, wave[w].y);

    signed char dx = wave[w].dx;
    wave[w].x += dx;
    signed char dy = wave[w].dy;
    wave[w].y += dy;
    unsigned char interval = wave[w].interval;
    wave[w].wait = interval;

    wave[w].enemy_spawn -= enemies;
    wave[w].enemy_count -= enemies;
}

inline void stage_enemy_remove(unsigned char w, unsigned char e)
{
    unsigned char enemies = RemoveEnemy(e);
    wave[w].enemy_spawn += enemies;
}

inline void stage_enemy_hit(unsigned char w, unsigned char e, unsigned char b)
{
    unsigned char enemies = HitEnemy(e, b);
    wave[w].enemy_spawn += enemies;
}

void stage_logic()
{
    if(stage.playbook < stage.script.playbooks) {
        
        if(!(game.tickstage & 0x03)) {
            // printf("stage playbook=%03u, scenario=%03u, enemies=%03u", stage.playbook, stage.scenario, stage.enemy_count);
            
            for(unsigned char w=0; w<8; w++) {
                if(wave[w].used) {
                    if(!wave[w].wait) {
                        if(wave[w].enemy_count) {
                            if(wave[w].enemy_spawn) {
                                stage_enemy_add(w, wave[w].enemy_sprite, wave[w].enemy_flightpath);
                            }
                        } else {
                            wave[w].used = 0;
                            wave[w].finished = 1;
                        }
                    } else {
                       wave[w].wait--;
                    }
                }
#ifdef __WAVE_DEBUG
                gotoxy(0,30+w);
                printf("wave %02x  %02x  %02x  %02x  %02x  %02x ", w, wave[w].used, wave[w].wait, wave[w].enemy_count, wave[w].enemy_spawn, wave[w].finished);
#endif
            }

            for(unsigned char w=0; w<8; w++) {

                // Check if a wave has finished.
                if(wave[w].finished) {

                    // If there are more scenarios, create new waves based on the scenarios dependent on the finished wave.
                    bank_push_bram(); bank_set_bram(BRAM_STAGE); // stage_scenario is at BRAM_STAGE

                    unsigned int new_scenario = wave[w].scenario;
                    unsigned int wave_scenario = wave[w].scenario;
                    // TODO find solution for this loop, maybe with pointers?
                    while(new_scenario < stage.scenarios) {
                        stage_playbook_t* stage_playbook = stage.script.playbook;
                        stage_scenario_t* stage_scenario = stage_playbook[stage.playbook].scenario;

                        unsigned int prev = stage_scenario[new_scenario].prev;

                        if(prev == wave_scenario) {
                            // We create new waves from the scenarios that are dependent on the finished one.
                            // There must always be at least one that equals scenario of the previous scenario.
                            stage.ew = (stage.ew+1) & 0x07;
                            memcpy(&wave[stage.ew], &stage_scenario[new_scenario], sizeof(stage_scenario_t));
                            wave[stage.ew].used = 1;
                            wave[stage.ew].finished = 0;
                            wave[stage.ew].scenario = new_scenario;
                        }
                        new_scenario++;
                    }
                    bank_pull_bram();
                    wave[w].finished = 0;
                }
            }

            if(stage.scenario >= stage.scenarios) {
                if(stage.playbook < stage.script.playbooks) {
                    stage.playbook++;
                    bank_push_bram(); bank_set_bram(BRAM_STAGE);
                    stage_playbook_t* stage_playbook = stage.script.playbook;
                    stage.scenarios = stage_playbook[stage.playbook].scenarios;
                    stage.scenario = 0;
                    bank_pull_bram();
                }
            }
        }
    }

    if(stage.respawn) {
        stage.respawn--;
        if(!stage.respawn) {
#ifdef __PLAYER
            player_add();
#endif
        }
    }
}
