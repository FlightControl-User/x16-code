#include <cx16-heap.h>
#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-bullet.h"
#include "equinoxe-stage.h"

void FireBullet(Bullet* entity, char reload)
{

	heap_handle bullet_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, entity_size);

	Bullet* bullet = (Bullet*)heap_data_ptr(bullet_handle);
    memset(bullet, 0, entity_size);

	heap_data_list_insert(&stage.bullet_list, bullet_handle);

    signed int x = game.curr_mousex;
    signed int y = game.curr_mousey;
    if (entity->firegun)
        x += (signed char)16;
    fp3_set(&bullet->tx, x, 0);
	fp3_set(&bullet->ty, y, 0);
    fp3_set(&bullet->tdx, 0, 0);
	fp3_set(&bullet->tdy, -1, 0);
    bullet->health = 1;
    bullet->side = SIDE_PLAYER;
    entity->firegun = entity->firegun^1;

    bullet->sprite_offset = NextOffset(SPRITE_OFFSET_BULLET_START, SPRITE_OFFSET_BULLET_END, &stage.sprite_bullet);
    bullet->sprite_type = &SpriteBullet01;
	sprite_configure(bullet->sprite_offset, bullet->sprite_type);

    // gotoxy(0, 20);
    // printf("list = %x - ", stage.bullet_list);
    // printf("%u %i %i   ", bullet->sprite_offset, bullet->x, bullet->y);

    entity->reload = reload;

}


heap_handle RemoveBullet(heap_handle handle_remove) {
	heap_handle handle_next = heap_data_list_remove(&stage.bullet_list, handle_remove);
	heap_free(HEAP_SEGMENT_BRAM_ENTITIES, handle_remove); 
	return handle_next;
}


void LogicBullets()
{
    // gotoxy(0, 38);
    // printf("lb: list = %x, count = %u", stage.bullet_list, stage.bullet_count);
    if(!stage.bullet_list) return;

    char l = 0;

    heap_handle bullet_handle = stage.bullet_list;
    // gotoxy(40, 0);
    // printf("bullet_list = %x", stage.bullet_list);

    do {

        Bullet* bullet = (Bullet*)heap_data_ptr(bullet_handle);

        vera_sprite_offset sprite_offset = bullet->sprite_offset;

        fp3_add(&bullet->tx, &bullet->tdx);
        fp3_add(&bullet->ty, &bullet->tdy);

        // gotoxy(0, l+1);
        // printf("bullet : l=%03u, p=%04p o=%04x x=%04i y=%04i ", l, bullet, bullet->sprite_offset, bullet->x, bullet->y);

        if (bullet->ty.i <= -32)
        // if (bullet->y.i <= -32)
        {
            sprite_disable(sprite_offset);
            bullet_handle = RemoveBullet(bullet_handle);
            continue;
        }

        DrawBullet(bullet_handle);

        bullet_handle = bullet->next;

        
    } while (bullet_handle != stage.bullet_list);
}

inline void DrawBullet(heap_handle bullet_handle) {
    // gotoxy(40, 38);
    // printf("db: list = %x, count = %u - ", stage.bullet_list, stage.bullet_count);
    char l = 0;

    Bullet *bullet = (Bullet *)heap_data_ptr(bullet_handle);

    vera_sprite_offset sprite_offset = bullet->sprite_offset;

    sprite_enable(sprite_offset, bullet->sprite_type);
    sprite_animate(sprite_offset, bullet->sprite_type, 0, 0);
    // sprite_position(bullet->sprite_offset, bullet->x.i, bullet->y.i);
    sprite_position(sprite_offset, bullet->tx.i, bullet->ty.i);
    // gotoxy(40, 39 + l++);
    // printf("db: bullet = %p ", bullet);
    bullet_handle = bullet->next;
}