#include <cx16.h>
#include <cx16-veralib.h>
#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-enemy.h"
#include "equinoxe-stage.h"
#include "equinoxe-palette.h"

#include "levels/equinoxe-level01.h"

stage_t stage;

void stage_init(bram_bank_t bram_bank)
{
	game.delegate.Logic = &Logic;

	memset(&stage, 0, sizeof(stage_t));

	stage.level = 1;
	stage.phase = 1;

    unsigned int bytes = load_file(1,8,0, "level01.bin", bram_bank, (bram_ptr_t) 0xA000);
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

    enemy_init();
    player_init();
    bullet_init();

	memset(&stage, 0, sizeof(stage_t));

	stage.sprite_bullet = SPRITE_OFFSET_BULLET_START;
	stage.sprite_bullet_count = 0;
	stage.sprite_enemy = SPRITE_OFFSET_ENEMY_START;
	stage.sprite_enemy_count = 0;
	stage.sprite_player = SPRITE_OFFSET_PLAYER_START;
	stage.sprite_player_count = 0;

    stage.enemy_count[0] = 16;
    stage.enemy_spawn[0] = 2;
    stage.enemy_sprite[0] = &SpriteEnemy01;
    stage.enemy_flightpath[0] = action_flightpath_01;


    stage.enemy_count[1] = 16;
    stage.enemy_spawn[1] = 3;
    stage.enemy_sprite[1] = &SpriteEnemy02;
    stage.enemy_flightpath[1] = action_flightpath_02;

    stage.enemy_count[2] = 16;
    stage.enemy_spawn[2] = 4;
    stage.enemy_sprite[2] = &SpriteEnemy03;
    stage.enemy_flightpath[2] = action_flightpath_03;

    stage.enemy_count[3] = 32;
    stage.enemy_spawn[3] = 8;
    stage.enemy_sprite[3] = &SpriteEnemy04;
    stage.enemy_flightpath[3] = action_flightpath_04;

    stage.score = 0;
    stage.penalty = 0;
    stage.lives = 10;
    stage.respawn = 0;

    stage.step = 0;
    stage.steps = 4;

	player_add();
    
    
}


void stage_progress()
{
	switch(stage.level) {
		case 0:
            stage.step++;
			break;
		case 1:
            stage.step++;
			break;
		case 2:
            stage.step++;
			break;
	}
}

inline void stage_enemy_add(sprite_t* sprite, stage_flightpath_t* flights)
{
    unsigned char enemies = AddEnemy(sprite, flights);
    stage.enemy_spawn[stage.step] -= enemies;
    stage.enemy_count[stage.step] -= enemies;
}

inline void stage_enemy_remove(unsigned char e)
{
    unsigned char enemies = RemoveEnemy(e);
    stage.enemy_spawn[stage.step] += enemies;
}

inline void stage_enemy_hit(unsigned char e, unsigned char b)
{
    unsigned char enemies = HitEnemy(e, b);
    stage.enemy_spawn[stage.step] += enemies;
}

void stage_logic()
{


    if(stage.step < stage.steps) {
        if(!(game.tickstage & 0x0F)) {
            // gotoxy(0, 10);
            // printf("stage step=%03u, count=%03u, spawn=%03u", stage.step, stage.enemy_count[stage.step], stage.enemy_spawn[stage.step]);
            if(stage.enemy_count[stage.step]) {
                if(stage.enemy_spawn[stage.step]) {
                    stage_enemy_add(stage.enemy_sprite[stage.step], stage.enemy_flightpath[stage.step]);
                }
            } else {
                stage_progress();
            }
        }
    }

    if(stage.respawn) {
        stage.respawn--;
        if(!stage.respawn) {
            player_add();
        }
    }
}
