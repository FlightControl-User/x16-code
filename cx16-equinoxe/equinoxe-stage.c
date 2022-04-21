#include <cx16.h>
#include <cx16-veralib.h>
#include "equinoxe.h"
#include "equinoxe-player.h"
#include "equinoxe-enemy.h"
#include "equinoxe-stage.h"

void StageInit(void) {
	game.delegate.Logic = &Logic;

	memset(&stage, 0, sizeof(Stage));

	StageReset();

	stage.level = 1;
	stage.phase = 1;

	StageProgress();
}

vera_sprite_offset NextOffset(vera_sprite_id sprite_start, vera_sprite_id sprite_end, vera_sprite_id* sprite_id, unsigned char* count) {

	while(sprite_offsets[*sprite_id]) {
		*sprite_id = ((*sprite_id) >= sprite_end)?sprite_start:(*sprite_id)+1;
	}

	(*count)++;
	vera_sprite_offset sprite_offset = vera_sprite_get_offset(*sprite_id); 
	sprite_offsets[*sprite_id] = sprite_offset;
	return sprite_offset;
}


void FreeOffset(vera_sprite_offset sprite_offset, unsigned char* count) {
	vera_sprite_id sprite_id = vera_sprite_get_id(sprite_offset);
	sprite_offsets[sprite_id] = 0;
	(*count)--;
}

static void StageReset(void) {

	memset(&stage, 0, sizeof(Stage));

	enemy_pool = 0;
	player_pool = 0;
	bullet_pool = 0;
	engine_pool = 0;

    bullet_count = 0;

	stage.sprite_bullet = SPRITE_OFFSET_BULLET_START;
	stage.sprite_bullet_count = 0;
	stage.sprite_enemy = SPRITE_OFFSET_ENEMY_START;
	stage.sprite_enemy_count = 0;
	stage.sprite_player = SPRITE_OFFSET_PLAYER_START;
	stage.sprite_player_count = 0;

    stage.score = 0;
    stage.penalty = 0;
    stage.lives = 10;
    stage.respawn = 0;

	InitPlayer();

}

void StageProgress() {
	switch(stage.level) {
		case 1:
			stage.spawnenemycount = 120;
			stage.spawnenemytype = 1;
			break;
	}
}

void LogicStage() {
	if(stage.spawnenemycount) {
		if(!(game.tickstage & 0x0F)) {
			if(stage.sprite_enemy_count<4) {
        		stage.spawnenemycount -= SpawnEnemies(stage.spawnenemytype, 320, -32);
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
