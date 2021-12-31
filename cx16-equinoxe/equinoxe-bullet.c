#include <cx16-heap.h>
#include <cx16-mouse.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"

void FireBullet()
{

    // To fire bullets, we need the player entity to control the bullets and the reloading of bullets.
	Entity* player = (Entity*)heap_data_ptr(player_handle);

    heap_handle bullet_handle = heap_alloc(HEAP_SEGMENT_BRAM_ENTITIES, sizeof(Entity)); ///< Global
    // TODO fragment
    heap_handle bullet_list = stage.bullet_list;

    stage.bullet_list = bullet_handle;

    Entity *bullet = (Entity *)heap_data_ptr(bullet_handle);
    memset(bullet, 0, sizeof(Entity));

    // gotoxy(0,12);     printf("bullet: bullet_handle = %x ", bullet_handle);

    bullet->next = bullet_list;
    bullet->sprite_type = &SpriteBullet01;
    signed int x = game.curr_mousex;
    signed int y = game.curr_mousey;
    if (player->firegun)
        x += (signed char)16;
    bullet->x = (unsigned int)x;
    bullet->y = (unsigned int)y;
    bullet->dx = 0;
    bullet->dy = -8;
    bullet->health = 1;
    bullet->side = SIDE_PLAYER;
    player->firegun = player->firegun^1;

    stage.bullet_sprite = (stage.bullet_sprite<15)?stage.bullet_sprite++:0;
    bullet->sprite_offset = BULLET_SPRITE_OFFSET + stage.bullet_sprite;

    // gotoxy(0, 37);
    // printf("fb: list = %x, count = %u - ", stage.bullet_list, stage.bullet_count);
    // printf("%u %i %i   ", bullet->sprite_offset, bullet->x, bullet->y);

    player->reload = 4;
}

void LogicBullets()
{



    // gotoxy(0, 38);
    // printf("lb: list = %x, count = %u", stage.bullet_list, stage.bullet_count);
    char l = 0;

    heap_handle bullet_handle = stage.bullet_list;
    heap_handle prev_handle = stage.bullet_list;
    while (bullet_handle)
    {

        Entity *bullet = (Entity *)heap_data_ptr(bullet_handle);

        unsigned int x = bullet->x;
        unsigned int y = bullet->y;
        x += bullet->dx;
        y += bullet->dy;
        bullet->x = x;
        bullet->y = y;

        // gotoxy(0, 39 + l++);
        // printf("b : %u %p %u %i %i ", stage.bullet_count, bullet, bullet->sprite_offset, bullet->x, bullet->y);

        if (bullet->y > -32)
        {
        }
        else
        {
            sprite_disable(bullet->sprite_offset);

            heap_handle next_handle = bullet->next;
            if (prev_handle==bullet_handle)
            {
                // when it is the first element in the list.
                stage.bullet_list = 0;
                prev_handle = 0;
            }
            else
            {
                ((Entity *)heap_data_ptr(prev_handle))->next = 0;
            }
            // gotoxy(20, 39 + (l - 1));
            // printf("free = %x, prev = %x ", bullet_handle, prev_handle);
            heap_free(HEAP_SEGMENT_BRAM_ENTITIES, bullet_handle);
            bullet_handle = prev_handle;
        }
        prev_handle = bullet_handle;
        if (prev_handle)
        {
            bullet_handle = ((Entity *)heap_data_ptr(prev_handle))->next;
        }
        else
        {
            bullet_handle = 0;
        }
    }
}

void DrawBullets()
{

    // gotoxy(40, 38);
    // printf("db: list = %x, count = %u - ", stage.bullet_list, stage.bullet_count);
    char l = 0;
    heap_handle bullet_handle = stage.bullet_list;
    while (bullet_handle)
    {
        Entity *bullet = (Entity *)heap_data_ptr(bullet_handle);
        sprite_enable(bullet->sprite_offset, bullet->sprite_type);
        sprite_animate(bullet->sprite_offset, bullet->sprite_type, 0);
        sprite_position(bullet->sprite_offset, (int)(bullet->x-32), (int)(bullet->y-32));
        // gotoxy(40, 39 + l++);
        // printf("db: bullet = %p ", bullet);
        bullet_handle = ((Entity *)heap_data_ptr(bullet_handle))->next;
    }
}