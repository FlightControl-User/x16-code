// #include <cx16-bitmap.h>
#include "equinoxe-collision.h"
#include "equinoxe-bullet.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-player.h"
#include "equinoxe-stage.h"
#include "equinoxe-tower.h"
#include "equinoxe-enemy.h"
#include "equinoxe-types.h"
#include "equinoxe.h"
#include "stdio.h"

#pragma data_seg(Hash)
ht_item_t collision_hash;
collision_quadrant_t collision_quadrant;

#pragma data_seg(Data)
#pragma code_seg(Code)

void collision_init() {
    ht_init(&collision_hash);
    memset_fast((char *)&collision_quadrant, 0, 0); // 256 initializations of the quadrant cell array.
}

ht_key_t collision_key(unsigned char gx, unsigned char gy) {
    unsigned char key = gy + gx;
    return key;
    //  return (((unsigned int)(kx + ky))|(unsigned int)group<<4);
}

/**
 * @brief Add a new coordinate to the spacial grid.
 * This routine is very tricky. It requires to carefully determine which sectors
 * in the spacial grid are to be inserted in the has table.
 * And this is not obvious, sometimes also negative coordinates are given, like -64.
 * This has a risk of ending in an endless loop!
 * So the xmin and ymin are taken as char values, while the xmax and ymax values are taken as int values.
 * This to carefully compare the increment of ymin from 0x00F0 to 0x0100 and not to 0x0000!
 * Same for the xmin value. So the gx and gy values are also int to ensure that the addition is taken in two bytes.
 * But note that only the lower bytes of the int values are actually stored in the spacial grid coordinate system!
 *
 * @param ht
 * @param group
 * @param xmin
 * @param ymin
 * @param f
 */
void collision_insert(flight_index_t f) {

    unsigned char xmin = flight.xi[f] >> 2; 
    unsigned char ymin = flight.yi[f] >> 2;

    flight.cx[f] = xmin;
    flight.cy[f] = ymin;
    flight.collided[f] = 0;

    // The coordinates start at -63, so we add 16 to avoid negative numbers in the grid key.
    xmin += 16;
    ymin += 16;

    unsigned char xmax = ((unsigned char)xmin + 8) & 0b11110000;
    unsigned char ymax = ((unsigned char)ymin + 8) & 0b11110000;

    xmin >>= 4;
    xmax >>= 4;

    ymin = ymin & 0b11110000;

    for (unsigned char gx = xmin; gx <= xmax; gx += 1) {
        for (unsigned char gy = ymin; gy <= ymax; gy += 16) {
            ht_key_t ht_key = collision_key((unsigned char)gx, (unsigned char)gy);
            ht_insert(&collision_hash, ht_key, f);
            collision_quadrant.cell[gy + gx] += 1;
        }
    }
}

inline unsigned char collision_count(unsigned char gx, unsigned char gy) { return collision_quadrant.cell[gx + gy]; }

inline void collision_debug() {
    gotoxy(0, 0);
    printf("hash root = %04p, ", &collision_hash);
    printf("hash list = %04p, ", &ht_list);
    printf("hash quadrant = %04p \n", &collision_quadrant);

    ht_display(&collision_hash);
}

unsigned char collision_data(unsigned char collision, collision_decision_t *collision_decision) {

    unsigned char type = flight.type[collision];

    unsigned char side = flight.side[collision];
    unsigned char x = flight.cx[collision];
    unsigned char y = flight.cy[collision];
    unsigned char s = flight.cache[collision]; // Which sprite is it in the cache...

    collision_decision->collision = collision;
    collision_decision->s = s;
    collision_decision->x = x;
    collision_decision->y = y;
    collision_decision->side = side;
    collision_decision->type = type;
    collision_decision->min_x = x + sprite_cache.xmin[s];
    collision_decision->min_y = y + sprite_cache.ymin[s];
    collision_decision->max_x = x + sprite_cache.xmax[s];
    collision_decision->max_y = y + sprite_cache.ymax[s];

    return collision;
}

/**
 * @brief Equinoxe main collision detection routine.
 *
 * A spacial grid approach is implemented in the equinoxe gaming engine, to ensure
 * blazing performance during collision detection between all the game objects on the screen.
 *
 * Previously, at each frame, we have executed the during the object logic,
 * the movement calculations and image animations for the screen.
 * As part of this object logic, we have also created a spacial grid, using the collision_insert routines.
 * The grid_ routines uses the routine set ht.h, which is a set of routines to create a has table.
 *
 * This collision_detect detection routine, uses the created spacial grid to efficiently compare the positions of each
 * object relative to each other, and will only compare those objects which have opposite party sides.
 *
 * Each cell in the spacial grid is 64x64 pixels wide in terms of screen dimensions.
 * The dimensions of our screen is 640x480, so there are 10 spacial grid cells on the x axis and 8 spacial grid cells on the y axis.
 * For efficiency reasons to store the spacial grid into memory and to optimize the utilization of the byte architecture of the 6502,
 * we reduced the spacial grid resolution with 2 bits to the right, so we divided by 4 both the x and y coordinates,
 * resulting in the spacial grid dimension to be 160x120. Now the spacial grid has table can
 * be built up using only byte values, not integers. So the x and y coordinate in the spacial grid can now be stored in 4 bits each,
 * where the x coordinate takes the lower nibble of the coordinate byte, and the y coordinate the higher nibble of the coordinate byte.
 *
 * So the spacial grid coordinate system **is stored in a hash table** with the x and y coordinates as the key, which is one byte wide!
 * This results in a very fast calculation algorithm for the 6502, where searching through the has table only requires one byte to be hashed.
 * For further efficiency reasons, the has table implements for duplicate keys a linked list, where the links are stored in a pre-defined
 * array of again only byte sized indexes. Again very efficient for the 6502! the spacial grid uses only absolute addressiing,
 * so pointers are completely avoided, which results in fast processing on the 6502.
 *
 * Because the coordinates in the spacial grid are they in the spacial grid hash table,
 * each object stored in the grid cell will result in a linked list to be built up in the spacial grid hash table!
 * So again very efficient, as now we can take the first element of a spacial grid cell linked list, and iterate through that list to
 * verify each object in that list!
 *
 * The collision detection loops through each cell in the spacial grid. Thus, it will loop horizontally 10 cells and vertically 8 cells.
 * 80 cells in total, however this loop is very efficient as it is only on byte level.
 *
 * During each spacial grid cell evaluation, it performs an outer and an inner loop,
 * where it compares the positions and the properties of the objects in the spacial grid cell against each other
 * using the linked list in the spacial grid hash table.
 *
 * And it does it in a special way, so that no object will be compared twice!
 * The outer loop will loop the complete linked list of the hashed grid cell.
 * The inner loop will only loop from the start position of the outer loop and taking the next element in that list as the start.
 *
 * For example, consider we have in the spacial grid cell the following objects A, B, C, D, E.
 * Then the outer loop will loop from A to E, while the inner loop will take for each element of the outer loop the next starting position.
 * So it will loop as follows:
 *
 *   | LOOP ITERATION | 1       | 2     | 3   | 4 |
 *   | -------------: | :-----: | :---: | :-: | - |
 *   | OUTER LOOP     | A       | B     | C   | D |
 *   | INNER LOOP     | B C D E | C D E | D E | E |
 *
 * This results in the minimal sets of objects to be compared witḣ each other, and thus, the most optimizal performance!
 *
 * On top of this comparison the properties of each object are evaluated. Each object as a coalition side,
 * which can be SIDE_FRIENDLY or SIDE_ENEMY. The game setup will only require objects to be compared with different coalitions.
 * So objects of the same coalition are never compared. SIDE_FRIENDLY is never compared with SIDE_FRIENDLY and SIDE_ENEMY is never compared with SIDE_ENEMY.
 *
 * Each object has an AABB or bounding box defined, that contains the dimensions of each object to be taken into account when comparing
 * the bounding box overlap between the objects in the spacial grid cell.
 *
 *
 */
void collision_detect() {

#ifdef __DEBUG_COLLISION
#ifndef __CONIO_BSOUT
    clrscr();
#endif
#endif

    // The collision key needs the gx and gy so that the key can be calculated using a simple addition.
    // We walk each row on the grid on the y-asis using the gy variable. There are in total 8 rows (480+64)/64.
    // However, we ensure that gy contains the sum of all the cells of each row considered,
    // so gy is incremented with a precision of 16, assuming that each row contains 16 cells.
    for (unsigned char gy = 0; gy < ((480 + 64) >> 2); gy += (64 >> 2)) {

        // we walk each column on the row using the gx variable. Each row has 11 (640+64)/64 cells, (to deal with border collisions too).
        // We consider gx to be incremented for each cell in the column/row combination, so gx is incremented by 1!
        for (unsigned char gx = 0; gx < ((640 + 64) >> (2 + 4)); gx += (64 >> (2 + 4))) {

            // Now that we have a collision, we need to check for each object in the cell the collision rules to each other.
            // Since we have the spacial hash, where each collision in the hash is a list,
            // we can easily walk the the collision list in an n(+m) x m mode, comparing each collision and its rules.

            if (collision_count(gx, gy)) {

                ht_key_t ht_key_outer = collision_key(gx, gy);
                ht_index_t ht_index_outer = ht_get(&collision_hash, ht_key_outer);

                while (ht_index_outer) {

                    ht_index_t ht_index_inner = ht_get_next(ht_index_outer);

                    // We only execute the outer calculations if there is an inner grid part, otherwise we just skip anyway.
                    // This is done to make the collision detection as short as possible.
                    if (ht_index_inner) {

                        collision_decision_t collision_outer;

                        unsigned char outer = (unsigned char)ht_get_data(ht_index_outer);
                        outer = collision_data(outer, &collision_outer);

                        while (ht_index_inner) {

                            collision_decision_t collision_inner;

                            unsigned char inner = (unsigned char)ht_get_data(ht_index_inner);
                            inner = collision_data(inner, &collision_inner);

                            // Now comes the collision test!

#ifdef __DEBUG_COLLISION
                            printf("\ngx=%03u, gy=%03u, inner=%03u, outer=%03u\n", gx, gy, inner, outer);
                            printf("\nos=%u, ot=%02x, ox=%04u, oy=%04u\n", collision_outer.side, collision_outer.type, collision_outer.x, collision_outer.y);
                            printf("is=%u, it=%02x, ix=%04u, iy=%04u\n", collision_inner.side, collision_inner.type, collision_inner.x, collision_inner.y);
#endif

                            if (collision_outer.side != collision_inner.side) {

                                if (collision_inner.min_x > collision_outer.max_x || collision_inner.min_y > collision_outer.max_y ||
                                    collision_inner.max_x < collision_outer.min_x || collision_inner.max_y < collision_outer.min_y) {
                                    // no collision
                                } else {

#ifdef __DEBUG_COLLISION
                                    printf("outer_min_x=%04x, inner_min_x=%04x \n", collision_outer.min_x, collision_inner.min_x);
                                    printf("outer_min_y=%04x, inner_min_y=%04x \n", collision_outer.min_y, collision_inner.min_y);
                                    printf("outer_max_x=%04x, inner_max_x=%04x \n", collision_outer.max_x, collision_inner.max_x);
                                    printf("outer_max_y=%04x, inner_max_y=%04x \n", collision_outer.max_y, collision_inner.max_y);
#endif
                                    // Collision happened

                                    if (collision_outer.side == SIDE_ENEMY) {
                                        switch (collision_outer.type) {
                                        case FLIGHT_BULLET:
#ifdef __DEBUG_COLLISION
                                            printf(", bullet %u -> ", outer);
#endif
                                            if (collision_inner.type == FLIGHT_PLAYER) {
#ifdef __DEBUG_COLLISION
                                                printf("player %u\n", inner);
#endif
                                                if(!bullet_has_collided(outer)) bullet_remove(outer);
                                                if(!player_has_collided(inner)) player_hit(inner, bullet_impact(outer));
                                            }
                                            break;

                                        case FLIGHT_ENEMY:
#ifdef __DEBUG_COLLISION
                                            printf(", enemy %u -> ", outer);
#endif
                                            if (collision_inner.type == FLIGHT_BULLET) {
#ifdef __DEBUG_COLLISION
                                                printf("bullet %u\n", inner);
#endif
                                                if(!enemy_has_collided(outer)) stage_enemy_hit(outer, bullet_impact(inner));
                                                if(!bullet_has_collided(inner)) bullet_remove(inner);
                                            }
                                            if (collision_inner.type == FLIGHT_PLAYER) {
#ifdef __DEBUG_COLLISION
                                                printf("player %u\n", inner);
#endif
                                                
                                                if(!enemy_has_collided(outer)) stage_enemy_hit(outer, player_impact(inner));
                                                if(!player_has_collided(inner)) player_hit(inner, enemy_impact(outer));
                                            }
                                            break;
                                        case FLIGHT_TOWER:
#ifdef __DEBUG_COLLISION
                                            printf(", tower %u -> ", outer);
#endif
                                            if (collision_inner.type == FLIGHT_BULLET) {
#ifdef __DEBUG_COLLISION
                                                printf("bullet %u\n", inner);
#endif
                                                if(!bullet_has_collided(inner)) bullet_remove(inner);
                                                // tower_hit(outer, inner);
                                            }
                                            break;
                                        }
                                    } else {
                                        // Friendly
                                        switch (collision_outer.type) {
                                        case FLIGHT_BULLET:
#ifdef __DEBUG_COLLISION
                                            printf(", bullet %u -> ", outer);
#endif
                                            if (collision_inner.type == FLIGHT_ENEMY) {
#ifdef __DEBUG_COLLISION
                                                printf("enemy %u\n", inner);
#endif
                                                // Remove first the enemy, then the bullet, because the bullet contains the energy of impact.
                                                if(!enemy_has_collided(inner)) stage_enemy_hit(inner, bullet_impact(outer));
                                                if(!bullet_has_collided(outer)) bullet_remove(outer);
                                            }
                                            if (collision_inner.type == FLIGHT_TOWER) {
#ifdef __DEBUG_COLLISION
                                                printf("tower %u\n", inner);
#endif
                                                if(!bullet_has_collided(outer)) bullet_remove(outer);
                                                // tower_hit(inner, outer);
                                            }
                                            break;

                                        case FLIGHT_PLAYER:
#ifdef __DEBUG_COLLISION
                                            printf(", player %u -> ", outer);
#endif
                                            if (collision_inner.type == FLIGHT_ENEMY) {
#ifdef __DEBUG_COLLISION
                                                printf("enemy %u\n", inner);
#endif
                                                
                                                if(!enemy_has_collided(inner)) stage_enemy_hit(inner, player_impact(outer));
                                                if(!player_has_collided(outer)) player_hit(outer, enemy_impact(inner));
                                            }
                                            break;
                                        }
                                    }
                                }
                            }
                            ht_index_inner = ht_get_next(ht_index_inner);
                        }
                    }
                    ht_index_outer = ht_get_next(ht_index_outer);
                }
            }
        }
    }
}
