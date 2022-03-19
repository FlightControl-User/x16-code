#include "equinoxe.h"
#include "equinoxe-flightengine.h"


inline void EnableFighter(unsigned char e) 
{
    sprite_enable(fighter.sprite_offset[e], fighter.sprite_type[e]);
    // EnableEngine(e);
}

inline void EnableEngine(unsigned char e) 
{
    if(e!=-1) {
        sprite_enable(fighter.sprite_offset[e], fighter.sprite_type[e]);
    }
}

inline void DisableFighter(unsigned char e) 
{
    sprite_disable(fighter.sprite_offset[e]);
    // DisableEngine(e);
}

inline void DisableEngine(unsigned char e) 
{
    if(e!=-1) {
        sprite_disable(fighter.sprite_offset[e]);
    }
}

inline void DrawEngine(unsigned char e) 
{
    if(e!=-1) {
        sprite_animate(fighter.sprite_offset[e], fighter.sprite_type[e], fighter.state_animation[e], fighter.wait_animation[e]);
        sprite_position(fighter.sprite_offset[e], WORD1(fighter.tx[e]), WORD1(fighter.ty[e]));
    }
}

inline void DrawFighter(unsigned char e) 
{
    sprite_animate(fighter.sprite_offset[e], fighter.sprite_type[e], fighter.state_animation[e], fighter.wait_animation[e]);
    sprite_position(fighter.sprite_offset[e], WORD1(fighter.tx[e]), WORD1(fighter.ty[e]));
    sprite_collision(fighter.sprite_offset[e], 0b10000000);
    // DrawEngine(e);
}
