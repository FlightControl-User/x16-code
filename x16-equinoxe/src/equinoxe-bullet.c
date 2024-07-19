#pragma link("equinoxe-lib.ld")

#pragma encoding(petscii_mixed)
#pragma var_model(mem)

#pragma lib_configure
#pragma lib_export(__varcall, bullet_init, bullet_add, bullet_logic)

#pragma calling(__phicall)

#include "equinoxe-cx16.h"
#include "equinoxe-math.h"
#include "equinoxe-bullet.h"

#include <equinoxe-animate.p>
#include <equinoxe-flightengine.p>
#include <equinoxe-collision.p>

#include "equinoxe-stage-flight.p"

#ifdef __BANKING
#pragma code_seg(CODE_ENGINE_BULLETS)
#pragma data_seg(DATA_ENGINE_BULLETS)
#pragma bank(cx16_ram,BANK_ENGINE_BULLETS)
#endif

#ifdef __BULLET

void bullet_init()
{
}

flight_index_t bullet_add(unsigned int sx, unsigned int sy, unsigned int tx, unsigned int ty, unsigned char speed, flight_side_t side, sprite_index_t sprite_bullet)
{
    flight_index_t b = flight_add(FLIGHT_BULLET, side, sprite_bullet);

    unsigned char asx = BYTE0(sx >> 2);
    unsigned char asy = BYTE0(sy >> 2);
    unsigned char atx = BYTE0(tx >> 2); 
    unsigned char aty = BYTE0(ty >> 2);

    unsigned char angle = math_atan2(asx, atx, asy, aty);

    signed int dx = math_vecx(angle-16, speed);
    signed int dy = math_vecy(angle-16, speed);  

    flight.xd[b] = (unsigned int)dx;
    flight.yd[b] = (unsigned int)dy;

    flight.xi[b] = sx;
    flight.yi[b] = sy;

    flight.speed[b] = speed; 

    flight.animate[b] = animate_add(
        sprite_cache.count[flight.cache[b]], 
        0, 
        sprite_cache.loop[flight.cache[b]], 
        1, 
        1, 
        sprite_cache.reverse[flight.cache[b]]
        );

    signed char impact = (signed char)(BYTE0(rand())>>4);
    flight.health[b] = 0;
    flight.impact[b] = -impact;
    
    return b;
}


void bullet_logic()
{
    flight_index_t b = flight_root(FLIGHT_BULLET);
    while(b) {
        flight_index_t bn = flight_next(b);
        if(flight.type[b] == FLIGHT_BULLET && flight.used[b]) {

            vera_sprite_offset sprite_offset = flight.sprite_offset[b];

            char* const xf = (char*)&flight.xf;
            char* const yf = (char*)&flight.yf;
            char* const xi = (char*)&flight.xi;
            char* const yi = (char*)&flight.yi;
            char* const xd = (char*)&flight.xd;
            char* const yd = (char*)&flight.yd;

            {kickasm(uses xf, uses yf, uses xi, uses yi, uses xd, uses yd) {{
                lda b
                asl
                tay
                ldx b
                lda xf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc xd,y        // Add the low byte (=fractional part) of the delta.
                sta xf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda xi,y        // Load the low byte of the integer part of the coordinate.
                adc xd+1,y      // Add the high byte (=integer part) of the delta.
                sta xi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda xd+1,y      // Load back the high byte of the axis delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc xi+1,y      // Now do the signed final addition.
                sta xi+1,y      // And store the result, we're done.

                lda yf,x        // Load the fractional part of the coordinate.
                clc             // For addition, clear the carry.
                adc yd,y        // Add the low byte (=fractional part) of the delta.
                sta yf,x        // Store the low byte of the delta in the fractional part of the coordinate.
                lda yi,y        // Load the low byte of the integer part of the coordinate.
                adc yd+1,y      // Add the high byte (=integer part) of the delta.
                sta yi,y        // Store the result in the low byte of the integer part of the coordinate.
                lda yd+1,y      // Load back the high byte of the delta, it may be negative.
                ora #$7f        // We check the sign bit.
                bmi !+          // If it was minus, the result in A will be $FF.
                lda #0          // The result was not minus, so just add carry.
                !:
                adc yi+1,y      // Now do the signed final addition.
                sta yi+1,y      // And store the result, we're done.
            }};}

            unsigned int x = flight.xi[b];
            unsigned int y = flight.yi[b];

            if(x<640 && y<480 && x<0xFFFF-32 && y<0xFFFF-32) {

                unsigned char volatile a = flight.animate[b];
                animate_logic(a);

#ifdef __COLLISION
				collision_insert(b);
#endif
            } else {
                stage_bullet_remove(b);
            }
        }
        b = bn;
    }
}

// Unbanked functions

#pragma code_seg(Code)
#pragma data_seg(Data)
#pragma nobank


inline void bullet_bank() {
    bank_push_set_bram(BANK_ENGINE_BULLETS);
}

inline void bullet_unbank() {
    bank_pull_bram();
}

#endif