#include <cx16.h>
#include <cx16-veralib.h>
#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-enemy.h"
#include "equinoxe-stage.h"
#include "equinoxe-palette.h"

stage_t stage;

void StageInit(void)
{
	game.delegate.Logic = &Logic;

	memset(&stage, 0, sizeof(stage_t));

	StageReset();

	stage.level = 1;
	stage.phase = 1;

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


static void StageReset(void)
{

	memset(&stage, 0, sizeof(stage_t));

	enemy_pool = 0;
	player_pool = 0;
	bullet_pool = 0;
	engine_pool = 0;

    bullet_count = 0;
    player_count = 0;

	stage.sprite_bullet = SPRITE_OFFSET_BULLET_START;
	stage.sprite_bullet_count = 0;
	stage.sprite_enemy = SPRITE_OFFSET_ENEMY_START;
	stage.sprite_enemy_count = 0;
	stage.sprite_player = SPRITE_OFFSET_PLAYER_START;
	stage.sprite_player_count = 0;

    stage.enemy_count[0] = 16;
    stage.enemy_spawn[0] = 2;
    stage.enemy_sprite[0] = &SpriteEnemy01;
    stage.enemy_flightpath[0] = enemy01_flightpath;

    

    stage.enemy_count[1] = 16;
    stage.enemy_spawn[1] = 2;
    stage.enemy_sprite[1] = &SpriteEnemy03;
    stage.enemy_flightpath[1] = enemy03_flightpath;


    stage.score = 0;
    stage.penalty = 0;
    stage.lives = 10;
    stage.respawn = 0;

    stage.step = 0;
    stage.steps = 2;

	InitPlayer();
    
    palette64_use(0);
    
}


void StageProgress()
{
	switch(stage.level) {
		case 0:
            stage.step++;
			break;
		case 1:
            stage.step++;
			break;
	}
}

inline void StageAddEnemy(sprite_t* sprite, enemy_flightpath_t* flights)
{
    unsigned char enemies = AddEnemy(sprite, flights);
    stage.enemy_spawn[stage.step] -= enemies;
    stage.enemy_count[stage.step] -= enemies;
}

inline void StageRemoveEnemy(unsigned char e)
{
    unsigned char enemies = RemoveEnemy(e);
    stage.enemy_spawn[stage.step] += enemies;
}

inline void StageHitEnemy(unsigned char e, unsigned char b)
{
    unsigned char enemies = HitEnemy(e, b);
    stage.enemy_spawn[stage.step] += enemies;
}

void LogicStage()
{


    if(stage.step < stage.steps) {
        if(!(game.tickstage & 0x0F)) {
            // gotoxy(0, 10);
            // printf("stage step=%03u, count=%03u, spawn=%03u", stage.step, stage.enemy_count[stage.step], stage.enemy_spawn[stage.step]);
            if(stage.enemy_count[stage.step]) {
                if(stage.enemy_spawn[stage.step]) {
                    StageAddEnemy(stage.enemy_sprite[stage.step], stage.enemy_flightpath[stage.step]);
                }
            } else {
                StageProgress();
            }
        }
    }

    if(stage.respawn) {
        stage.respawn--;
        if(!stage.respawn) {
            InitPlayer();
        }
    }
}
