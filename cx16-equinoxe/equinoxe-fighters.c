#include <cx16-heap.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"

void DrawFighters()
{

    if(!stage.fighter_list) return;

    heap_handle fighter_handle = stage.fighter_list;

    do {
        // gotoxy(0,11); printf("debug = %u, handle = %x, next = %x", debug_count++, fighter_handle, ((entity_t*)heap_data_ptr(fighter_handle))->next);
        entity_t* fighter = (entity_t*)heap_data_ptr(fighter_handle);
        heap_handle engine_handle = fighter->engine_handle;
        unsigned char disable = 0;
        if(fighter->tx.i > -64) {
            if(fighter->tx.i < 640) {
                sprite_enable(fighter->sprite_offset, fighter->sprite_type);
                sprite_animate(fighter->sprite_offset, fighter->sprite_type, fighter->state_animation);
                sprite_position(fighter->sprite_offset, fighter->tx.i, fighter->ty.i);
                if(engine_handle) {
                    entity_t* engine = (entity_t*)heap_data_ptr(engine_handle);
                    sprite_enable(engine->sprite_offset, engine->sprite_type);
                    sprite_animate(engine->sprite_offset, engine->sprite_type, engine->state_animation);
                    sprite_position(engine->sprite_offset, engine->tx.i, engine->ty.i);
                }
            } else {
                disable = 1;
            }
        } else {
            disable = 1;
        }

        if(disable) {
            sprite_disable(fighter->sprite_offset);
            if(engine_handle) {
                entity_t* engine = (entity_t*)heap_data_ptr(engine_handle);
                sprite_disable(engine->sprite_offset);
            }
        }

        fighter_handle = ((entity_t*)heap_data_ptr(fighter_handle))->next;

	} while(fighter_handle != stage.fighter_list);

}
