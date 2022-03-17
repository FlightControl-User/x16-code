#include "equinoxe.h"
#include "equinoxe-flightengine.h"


inline void EnableFighter(heap_handle fighter_handle) 
{
    entity_t* fighter = (entity_t*)heap_ptr(fighter_handle);
    sprite_enable(fighter->sprite_offset, fighter->sprite_type);
    EnableEngine(fighter->engine_handle);
}

inline void EnableEngine(heap_handle engine_handle) 
{
    if(heap_handle_is_not_null(engine_handle)) {
        entity_t* engine = (entity_t*)heap_ptr(engine_handle);
        sprite_enable(engine->sprite_offset, engine->sprite_type);
    }
}

inline void DisableFighter(heap_handle fighter_handle) 
{
    entity_t* fighter = (entity_t*)heap_ptr(fighter_handle);
    sprite_disable(fighter->sprite_offset);
    DisableEngine(fighter->engine_handle);
}

inline void DisableEngine(heap_handle engine_handle) 
{
    if(heap_handle_is_not_null(engine_handle)) {
        entity_t* engine = (entity_t*)heap_ptr(engine_handle);
        sprite_disable(engine->sprite_offset);
    }
}

inline void DrawEngine(heap_handle engine_handle) 
{
    if(heap_handle_is_not_null(engine_handle)) {
        entity_t* engine = (entity_t*)heap_ptr(engine_handle);
        sprite_animate(engine->sprite_offset, engine->sprite_type, engine->state_animation, engine->wait_animation);
        sprite_position(engine->sprite_offset, engine->tx.fp3fi.i, engine->ty.fp3fi.i);
    }
}

inline void DrawFighter(heap_handle fighter_handle) 
{
    entity_t* fighter = (entity_t*)heap_ptr(fighter_handle);
    sprite_animate(fighter->sprite_offset, fighter->sprite_type, fighter->state_animation, fighter->wait_animation);
    sprite_position(fighter->sprite_offset, fighter->tx.fp3fi.i, fighter->ty.fp3fi.i);
    sprite_collision(fighter->sprite_offset, 0b10000000);
    DrawEngine(fighter->engine_handle);
}
