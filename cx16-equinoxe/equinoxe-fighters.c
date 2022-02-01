#include <cx16-heap.h>
#include "equinoxe.h"
#include "equinoxe-flightengine.h"

void DrawFighter(heap_handle fighter_handle) {

    if(!stage.fighter_list) return;

    entity_t* fighter = (entity_t*)heap_data_ptr(fighter_handle);
    heap_handle engine_handle = fighter->engine_handle;
    unsigned char disable = 0;

    signed int x = fighter->tx.i;
    signed int y =  fighter->ty.i;
    vera_sprite_offset sprite_offset = fighter->sprite_offset;
    
    if(x > -64) {
        if(x < 640) {
            sprite_enable(sprite_offset, fighter->sprite_type);
            sprite_animate(sprite_offset, fighter->sprite_type, fighter->state_animation);
            sprite_position(sprite_offset, x, y);
            if(engine_handle) {
                entity_t* engine = (entity_t*)heap_data_ptr(engine_handle);

                signed int x = engine->tx.i;
                signed int y =  engine->ty.i;
                vera_sprite_offset sprite_offset = engine->sprite_offset;

                sprite_enable(sprite_offset, engine->sprite_type);
                sprite_animate(sprite_offset, engine->sprite_type, engine->state_animation);
                sprite_position(sprite_offset, engine->tx.i, engine->ty.i);
            }
        } else {
            disable = 1;
        }
    } else {
        disable = 1;
    }

    if(disable) {
        entity_t* fighter = (entity_t*)heap_data_ptr(fighter_handle);
        vera_sprite_offset sprite_offset = fighter->sprite_offset;
        sprite_disable(sprite_offset);
        if(engine_handle) {
            entity_t* engine = (entity_t*)heap_data_ptr(engine_handle);
            vera_sprite_offset sprite_offset = engine->sprite_offset;
            sprite_disable(sprite_offset);
        }
    }
}
