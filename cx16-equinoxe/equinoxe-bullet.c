#include <cx16-heap.h>
#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-bullet.h"

void FireBullet(Bullet* entity, char reload)
{

	Bullet bullet_ram;
	Bullet* bullet = &bullet_ram;
	memset_fast(bullet, 0, sizeof(Bullet));

    bullet->sprite_type = &SpriteBullet01;
    signed int x = game.curr_mousex;
    signed int y = game.curr_mousey;
    if (entity->firegun)
        x += (signed char)16;
    bullet->x = x;
    bullet->y = y;
    bullet->dx = 0;
    bullet->dy = -8;
    bullet->health = 1;
    bullet->side = SIDE_PLAYER;
    entity->firegun = entity->firegun^1;

    stage.bullet_sprite = (stage.bullet_sprite<15)?stage.bullet_sprite++:0;
    bullet->sprite_offset = BULLET_SPRITE_OFFSET + stage.bullet_sprite;

    // gotoxy(0, 37);
    // printf("fb: list = %x, count = %u - ", stage.bullet_list, stage.bullet_count);
    // printf("%u %i %i   ", bullet->sprite_offset, bullet->x, bullet->y);

    entity->reload = reload;

	heap_handle bullet_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Bullet));
	Bullet* bullet_bram = (Bullet*)heap_data_ptr(bullet_handle);
	memcpy_fast(bullet_bram, bullet, sizeof(Bullet));
	heap_data_list_insert(&stage.bullet_list, bullet_handle);
}

heap_handle RemoveBullet(heap_handle handle_remove) {
	heap_handle handle_next = ((Bullet*)heap_data_ptr(handle_remove))->next;
	heap_data_list_remove(&stage.bullet_list, handle_remove);
	heap_free(HEAP_SEGMENT_BRAM_ENTITIES, handle_remove); 
	return handle_next;
}


void LogicBullets()
{
    // gotoxy(0, 38);
    // printf("lb: list = %x, count = %u", stage.bullet_list, stage.bullet_count);
    char l = 0;

    heap_handle bullet_handle = stage.bullet_list;
    heap_handle prev_handle = stage.bullet_list;
    do {

        Bullet *bullet_bram = (Bullet*)heap_data_ptr(bullet_handle);
        Bullet bullet_ram;
        Bullet* bullet = &bullet_ram;
        memcpy_fast(bullet, bullet_bram, sizeof(Bullet));

        bullet->x += bullet->dx;
        bullet->y += bullet->dy;

        gotoxy(0, 39 + l++);
        printf("b : %p %u %i %i ", bullet, bullet->sprite_offset, bullet->x, bullet->y);

        if (bullet->y <= -32)
        {
            sprite_disable(bullet->sprite_offset);
            bullet_handle = RemoveBullet(bullet_handle);
            continue;

            // heap_handle next_handle = bullet->next;
            // if (prev_handle==bullet_handle)
            // {
            //     // when it is the first element in the list.
            //     stage.bullet_list = 0;
            //     prev_handle = 0;
            // }
            // else
            // {
            //     ((Bullet *)heap_data_ptr(prev_handle))->next = 0;
            // }
            // // gotoxy(20, 39 + (l - 1));
            // // printf("free = %x, prev = %x ", bullet_handle, prev_handle);
            // heap_free(HEAP_SEGMENT_BRAM_ENTITIES, bullet_handle);
            // bullet_handle = prev_handle;
        }

        bullet_bram = (Bullet*)heap_data_ptr(bullet_handle);
        memcpy_fast(bullet_bram, bullet, sizeof(Bullet));

        bullet_handle = bullet->next;
        
    } while (bullet_handle != stage.bullet_list);
}

void DrawBullets()
{
    // gotoxy(40, 38);
    // printf("db: list = %x, count = %u - ", stage.bullet_list, stage.bullet_count);
    char l = 0;
    heap_handle bullet_handle = stage.bullet_list;
    
    do {
        Bullet *bullet = (Bullet *)heap_data_ptr(bullet_handle);
        sprite_enable(bullet->sprite_offset, bullet->sprite_type);
        sprite_animate(bullet->sprite_offset, bullet->sprite_type, 0);
        sprite_position(bullet->sprite_offset, bullet->x, bullet->y);
        // gotoxy(40, 39 + l++);
        // printf("db: bullet = %p ", bullet);
        bullet_handle = ((Bullet *)heap_data_ptr(bullet_handle))->next;
    } while (bullet_handle != stage.bullet_list);
}