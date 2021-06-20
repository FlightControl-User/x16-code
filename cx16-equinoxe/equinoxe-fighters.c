#include <cx16-heap.h>
#include "equinoxe.h"

void DrawFighters()
{
	for(heap_handle fighter_handle = stage.fighter_head; fighter_handle; fighter_handle = ((Entity*)heap_data_ptr(fighter_handle))->next) {
        Entity* fighter = (Entity*)heap_data_ptr(fighter_handle);
        sprite_enable(fighter->sprite_offset, fighter->sprite_type);
        sprite_animate(fighter->sprite_offset, fighter->sprite_type, fighter->state_animation);
        sprite_position(fighter->sprite_offset, fighter->x, fighter->y);

        heap_handle engine_handle = fighter->engine_handle;
        if(engine_handle) {
            Entity* engine = (Entity*)heap_data_ptr(engine_handle);
            sprite_enable(engine->sprite_offset, engine->sprite_type);
            sprite_animate(engine->sprite_offset, engine->sprite_type, engine->state_animation);
            sprite_position(engine->sprite_offset, engine->x, engine->y);
        }


	}
}
