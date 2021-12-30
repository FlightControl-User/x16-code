#include "equinoxe.h"
#include "equinoxe-player.h"

void StageInit(void) {
	game.delegate.Logic = &Logic;
	game.delegate.Draw = &Draw;

	memset(&stage, 0, sizeof(Stage));

	StageReset();
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

	stage.fighter_head = 0;
	stage.bullet_list = 0;
	stage.bullet_sprite = 0;
	
	InitPlayer();
	InitEnemies();

	// initStarfield();

	// enemySpawnTimer = 0;

	// stageResetTimer = FPS * 3;
}
