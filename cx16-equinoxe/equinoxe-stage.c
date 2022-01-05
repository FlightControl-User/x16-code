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

char NextOffset() {
	char i = 0;
	for(i=1;i<127;i++) {
		if(!stage.offsets[i]) {
			stage.offsets[i] = 1;
			return i;
		}
	}
	return 0;
}

void FreeOffset(char i) {
	stage.offsets[i] = 0;
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
			stage.spawnenemycount = 1;
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
