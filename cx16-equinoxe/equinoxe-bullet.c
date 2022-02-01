#include <cx16-heap.h>
#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-bullet.h"
#include "equinoxe-stage.h"

void FireBullet(Bullet* entity, char reload)
{

	heap_handle bullet_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Bullet));

	Bullet* bullet = (Bullet*)heap_data_ptr(bullet_handle);
    memset(bullet, 0, sizeof(Bullet));

	heap_data_list_insert(&stage.bullet_list, bullet_handle);

    signed int x = game.curr_mousex;
    signed int y = game.curr_mousey;
    if (entity->firegun)
        x += (signed char)16;
    bullet->x = x;
    bullet->y = y;
    bullet->dx = 0;
    bullet->dy = -8;
    // bullet->x = fp3_set(x,0);
    // bullet->y = fp3_set(y,0);
    // bullet->dx = fp3_set(0,0);
    // bullet->dy = fp3_set(-4,0);
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
    char l = 0;

    heap_handle bullet_handle = stage.bullet_list;
    // gotoxy(40, 0);
    // printf("bullet_list = %x", stage.bullet_list);

    do {

        Bullet* bullet = (Bullet*)heap_data_ptr(bullet_handle);

        vera_sprite_offset sprite_offset = bullet->sprite_offset;
        signed int x = bullet->x;
        signed int y = bullet->y;

        signed char dx = bullet->dx;
        signed char dy = bullet->dy;
        // FP3 dx = bullet->dx;
        // FP3 dy = bullet->dy;
        // FP3 x = bullet->x;
        // FP3 y = bullet->y;

        x += dx;
        y += dy;
        // bullet->x = fp3_add(x, dx);
        // bullet->y = fp3_add(y, dy);

        bullet->x = x;
        bullet->y = y;

        // gotoxy(0, l+1);
        // printf("bullet : l=%03u, p=%04p o=%04x x=%04i y=%04i ", l, bullet, bullet->sprite_offset, bullet->x, bullet->y);

        if (y <= -32)
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
    signed int x = bullet->x;
    signed int y = bullet->y;

    sprite_enable(sprite_offset, bullet->sprite_type);
    sprite_animate(sprite_offset, bullet->sprite_type, 0, 0);
    // sprite_position(bullet->sprite_offset, bullet->x.i, bullet->y.i);
    sprite_position(sprite_offset, x, y);
    // gotoxy(40, 39 + l++);
    // printf("db: bullet = %p ", bullet);
    bullet_handle = bullet->next;
}