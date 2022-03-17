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

vera_sprite_offset NextOffset(vera_sprite_id sprite_start, vera_sprite_id sprite_end, vera_sprite_id* sprite_id) {
	vera_sprite_id count = sprite_end-sprite_start;
	while(count) {
		vera_sprite_offset sprite_offset = sprite_offsets[*sprite_id];
		if(!sprite_offset) {
			// sprite_offset = (vera_sprite_offset)((*sprite_id)<<3)+(vera_sprite_offset)sprite_buffer; 
			sprite_offset =  vera_sprite_get_offset(*sprite_id); 
			sprite_offsets[*sprite_id] = sprite_offset;
			return sprite_offset;
		}
		count--;
		*sprite_id = (*sprite_id==sprite_end) ? sprite_start : (*sprite_id)++;
	}
	return 0;
}


void FreeOffset(vera_sprite_offset sprite_offset) {
	vera_sprite_id sprite_id = vera_sprite_get_id(sprite_offset);
	sprite_offsets[sprite_id] = 0;
}

static void StageReset(void) {
	// entity_t *e;
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
	
	InitPlayer();

	// initStarfield();

	// enemySpawnTimer = 0;

	// stageResetTimer = FPS * 3;
}

void StageProgress() {
	switch(stage.level) {
		case 1:
			stage.spawnenemycount = 30;
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
