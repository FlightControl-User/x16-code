#include <cx16.h>
#include "equinoxe.h"
#include "equinoxe-stage.h"
#include "equinoxe-animate.h"
#include "equinoxe-flightengine.h"

void animate_init()
{
    bank_push_set_bram(BRAM_FLIGHTENGINE);
    memset(&animate, 0, sizeof(sprite_animate_t));
    bank_pull_bram();
}

unsigned char animate_add()
{
    bank_push_set_bram(BRAM_FLIGHTENGINE);

    if(stage.animate_count < SPRITE_ANIMATE) {
        while(animate.used[stage.animate_pool]) {
            stage.animate_pool = (stage.animate_pool+1) % SPRITE_ANIMATE;
        }

        stage.animate_count++;
    }

    bank_pull_bram();

    return stage.animate_pool;
}

inline void animate_logic(unsigned char a)
{

    // bank_push_set_bram(BRAM_FLIGHTENGINE);

    if(!animate.wait[a]) {
        animate.wait[a] = animate.speed[a];
        animate.state[a] += animate.direction[a];
        if(animate.direction[a]) {
            if(animate.direction[a]>0) {            
                if(animate.state[a] >= animate.count[a]) {
                    if(animate.reverse[a]) {
                        animate.direction[a] = -1;                            
                    } else {
                        animate.state[a] = animate.loop[a];
                    }
                }
            }

            if(animate.direction[a]<0) {
                if(animate.state[a] <= animate.loop[a]) {
                    animate.direction[a] = 1;                            
                }
            }
            
        }
    }

    if(animate.speed[a])
        animate.wait[a]--;

    // bank_pull_bram();

}
