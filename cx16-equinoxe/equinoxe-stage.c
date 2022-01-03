#include "equinoxe.h"
#include "equinoxe-player.h"
#include "equinoxe-enemy.h"

void StageInit(void) {
	game.delegate.Logic = &Logic;
	game.delegate.Draw = &Draw;

	memset(&stage, 0, sizeof(Stage));

	StageReset();
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
	AddEnemy(1, 20, 10);
	// {
	// gotoxy(0,0);
	// printf("1\n");
    // heap_handle enemy_handle = stage.fighter_list;
    // heap_handle last_handle = stage.fighter_list;
	// do {

	// 	Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);
	// 	printf("enemy = %p, enemy_handle = %x, next = %x, prev = %x\n", enemy, enemy_handle, enemy->next, enemy->prev);
	// 	enemy_handle = enemy->next;
	// } while (enemy_handle != last_handle);
	// }

	AddEnemy(1, 50, 40);
	// {
	// printf("2\n");
    // heap_handle enemy_handle = stage.fighter_list;
    // heap_handle last_handle = stage.fighter_list;
	// do {

	// 	Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);
	// 	printf("enemy = %p, enemy_handle = %x, next = %x, prev = %x\n", enemy, enemy_handle, enemy->next, enemy->prev);
	// 	enemy_handle = enemy->next;
	// } while (enemy_handle != last_handle);
	// }
	AddEnemy(1, 80, 70);
	// {
	// printf("3\n");
    // heap_handle enemy_handle = stage.fighter_list;
    // heap_handle last_handle = stage.fighter_list;
	// do {

	// 	Enemy* enemy = (Enemy*)heap_data_ptr(enemy_handle);
	// 	printf("enemy = %p, enemy_handle = %x, next = %x, prev = %x\n", enemy, enemy_handle, enemy->next, enemy->prev);
	// 	enemy_handle = enemy->next;
	// } while (enemy_handle != last_handle);
	// }
	// AddEnemy(1, 110, 100);
	// AddEnemy(1, 140, 130);
	// AddEnemy(1, 170, 160);
	// AddEnemy(1, 200, 190);
	// AddEnemy(1, 230, 220);

	// initStarfield();

	// enemySpawnTimer = 0;

	// stageResetTimer = FPS * 3;
}
