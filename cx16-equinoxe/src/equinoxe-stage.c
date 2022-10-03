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
stage_wave_t wave;

void stage_init(bram_bank_t bram_bank)
{
	memset(&stage, 0, sizeof(stage_t));

    unsigned int bytes = file_load_bram(1,8,0, "levels.bin", bram_bank, (bram_ptr_t) 0xA000);
    printf("level loaded, %x bytes\n", bytes);

}



void stage_copy(unsigned char ew, unsigned int scenario) {
    stage_playbook_t* stage_playbook = stage.script.playbook;
    stage_scenario_t* stage_scenario = stage_playbook[stage.playbook].scenario;

    wave.dx[ew] = stage_scenario[scenario].dx;
    wave.dy[ew] = stage_scenario[scenario].dy;
    wave.enemy_count[ew] = stage_scenario[scenario].enemy_count;
    wave.enemy_flightpath[ew] = stage_scenario[scenario].enemy_flightpath;
    wave.enemy_spawn[ew] = stage_scenario[scenario].enemy_spawn;
    wave.enemy_sprite[ew] = stage_scenario[scenario].enemy_sprite;
    wave.interval[ew] = stage_scenario[scenario].interval;
    wave.prev[ew] = stage_scenario[scenario].prev;
    wave.wait[ew] = stage_scenario[scenario].wait;
    wave.x[ew] = stage_scenario[scenario].x;
    wave.y[ew] = stage_scenario[scenario].y;
    wave.used[ew] = 1;
    wave.finished[ew] = 0;
    wave.scenario[ew] = scenario;
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

    stage_copy(stage.ew, stage.scenario);

    stage.playbook = 0;
    stage.scenario = 0;
    stage.scenarios = stage_playbook[stage.playbook].scenarios;

    // printf("stage.scenarios = %u", stage.scenarios);

    bank_pull_bram();

#ifdef __PLAYER
    // Add the player to the stage.
	player_add();
#endif
}


/* inline */ void stage_enemy_add(unsigned char w, sprite_bram_t* sprite, stage_flightpath_t* flights)
{
    unsigned char enemies = AddEnemy(w, sprite, flights, wave.x[w], wave.y[w]);

    wave.x[w] += wave.dx[w];
    wave.y[w] += wave.dy[w];
    wave.wait[w] = wave.interval[w];
    wave.enemy_spawn[w] -= enemies;
    wave.enemy_count[w] -= enemies;
}

/* inline */ void stage_enemy_remove(unsigned char w, unsigned char e)
{
    unsigned char enemies = RemoveEnemy(e);
    wave.enemy_spawn[w] += enemies;
}

/* inline */ void stage_enemy_hit(unsigned char w, unsigned char e, unsigned char b)
{
    unsigned char enemies = HitEnemy(e, b);
    wave.enemy_spawn[w] += enemies;
}

void stage_logic()
{
    if(stage.playbook < stage.script.playbooks) {
        
        if(!(game.tickstage & 0x03)) {
            // printf("stage playbook=%03u, scenario=%03u, enemies=%03u", stage.playbook, stage.scenario, stage.enemy_count);
            
            for(unsigned char w=0; w<8; w++) {
                if(wave.used[w]) {
                    if(!wave.wait[w]) {
                        if(wave.enemy_count[w]) {
                            if(wave.enemy_spawn[w]) {
                                stage_enemy_add(w, wave.enemy_sprite[w], wave.enemy_flightpath[w]);
                            }
                        } else {
                            wave.used[w] = 0;
                            wave.finished[w] = 1;
                        }
                    } else {
                       wave.wait[w]--;
                    }
                }
#ifdef __WAVE_DEBUG
                gotoxy(0,30+w);
                printf("wave %02x  %02x  %02x  %02x  %02x  %02x ", w, wave.used[w], wave.wait[w], wave.enemy_count[w], wave.enemy_spawn[w], wave.finished[w]);
#endif
            }

            for(unsigned char w=0; w<8; w++) {

                // Check if a wave has finished.
                if(wave.finished[w]) {

                    // If there are more scenarios, create new waves based on the scenarios dependent on the finished wave.
                    bank_push_bram(); bank_set_bram(BRAM_STAGE); // stage_scenario is at BRAM_STAGE

                    unsigned int new_scenario = wave.scenario[w];
                    unsigned int wave_scenario = wave.scenario[w];
                    // TODO find solution for this loop, maybe with pointers?
                    while(new_scenario < stage.scenarios) {
                        stage_playbook_t* stage_playbook = stage.script.playbook;
                        stage_scenario_t* stage_scenario = stage_playbook[stage.playbook].scenario;

                        unsigned int prev = stage_scenario[new_scenario].prev;

                        if(prev == wave_scenario) {
                            // We create new waves from the scenarios that are dependent on the finished one.
                            // There must always be at least one that equals scenario of the previous scenario.
                            stage.ew = (stage.ew+1) & 0x07;
                            stage_copy(stage.ew, new_scenario);
                        }
                        new_scenario++;
                    }
                    bank_pull_bram();
                    wave.finished[w] = 0;
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
