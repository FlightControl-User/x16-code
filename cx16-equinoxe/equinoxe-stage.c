#include "equinoxe.h"
#include "equinoxe-player.h"
#include "equinoxe-enemy.h"

void StageInit(void) {
	game.delegate.Logic = &Logic;
	game.delegate.Draw = &Draw;

	memset(&stage, 0, sizeof(Stage));

	StageReset();

	stage.level = 1;
	stage.phase = 1;

	StageProgress();
}

vera_sprite_offset NextOffset() {
	vera_sprite_id sprite_id = 1;
	for(sprite_id = 1; sprite_id < 127; sprite_id++) {
		vera_sprite_offset sprite_offset = sprite_offsets[sprite_id];
		if(!sprite_offset) {
			sprite_offset =  vera_sprite_get_offset(sprite_id); 
			sprite_offsets[sprite_id] = sprite_offset;
			return sprite_offset;
		}
	}
	return 0;
}

void FreeOffset(vera_sprite_offset sprite_offset) {
	vera_sprite_id sprite_id = vera_sprite_get_id(sprite_offset);
	sprite_offsets[sprite_id] = 0;
}

static void StageReset(void) {
	// Entity *e;
	// Explosion *ex;
	// Debris *d;

	// while (stage.fighterHead.next)
	// {
	// 	e = stage.fighterHead.next;
	// 	stage.fighterHead.next = e->next;
	// 	free(e);
	// }

	// while (stage.bulletHead.next)
	// {
	// 	e = stage.bulletHead.next;
	// 	stage.bulletHead.next = e->next;
	// 	free(e);
	// }

	// while (stage.explosionHead.next)
	// {
	// 	ex = stage.explosionHead.next;
	// 	stage.explosionHead.next = ex->next;
	// 	free(ex);
	// }

	// while (stage.debrisHead.next)
	// {
	// 	d = stage.debrisHead.next;
	// 	stage.debrisHead.next = d->next;
	// 	free(d);
	// }

	memset(&stage, 0, sizeof(Stage));
	// stage.fighterTail = &stage.fighterHead;
	// stage.bulletTail = &stage.bulletHead;
	// stage.explosionTail = &stage.explosionHead;
	// stage.debrisTail = &stage.debrisHead;

	stage.fighter_list = 0;
	stage.bullet_list = 0;
	stage.bullet_sprite = 0;
	
	InitPlayer();

	// initStarfield();

	// enemySpawnTimer = 0;

	// stageResetTimer = FPS * 3;
}

void StageProgress() {
	switch(stage.level) {
		case 1:
			stage.spawnenemycount = 20;
			stage.spawnenemytype = 1;
			break;
	}
}

void LogicStage() {
	if(stage.spawnenemycount) {
		if(!(game.tickstage & 0x0F)) {
        	stage.spawnenemycount -= SpawnEnemies(stage.spawnenemytype, 0, 240);
		}
    }
}
