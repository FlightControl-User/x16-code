#include "equinoxe-types.h"
#include "equinoxe-flightengine.h"
#include "equinoxe-collision.h"
#include "stdio.h"
#include <cx16-bitmap.h>

#pragma var_model(zp)

ht_key_t collision_key(unsigned char gx, unsigned char gy)
{
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
 * @param data
 */
void collision_insert(ht_item_t* ht, unsigned char xmin, unsigned char ymin, ht_data_t data)
{

    // bram_bank_t bram_old = bank_get_bram();
    // bank_set_bram(60);

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
            // printf("cell %02x,%02x:%02x(%02x)", gx, gy, ht_key, data);
            ht_insert(ht, ht_key, data);
        }
    }
    // bank_set_bram(bram_old);
}

void collision_print(ht_item_t* ht)
{
    bram_bank_t bram_old = bank_get_bram();
    bank_set_bram(60);
    ht_display(ht);
    bank_set_bram(bram_old);
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
void collision_detect()
{

    bank_push_set_bram(BRAM_FLIGHTENGINE);

#ifdef __DEBUG_COLLISION
#ifndef __CONIO_BSOUT
    clrscr();
#endif
#endif

    for (unsigned char gy=0; gy<((480+64)>>2); gy+=(64>>2)) {

        for (unsigned char gx=0; gx < ((640+64)>>(2+4)); gx+=(64>>(2+4))) {

            ht_key_t ht_key_outer = collision_key(gx, gy);
            ht_index_t ht_index_outer = ht_get(&ht_collision, ht_key_outer);

            while (ht_index_outer) {


                ht_index_t ht_index_inner = ht_get_next(ht_index_outer);

                // We only execute the outer calculations if there is an inner grid part, otherwise we just skip anyway.
                // This is done to make the collision detection as short as possible.
                if (ht_index_inner) {

                    unsigned char outer = (unsigned char)ht_get_data(ht_index_outer);

                    unsigned char outer_type = outer & COLLISION_MASK;
                    outer = outer & ~COLLISION_MASK;

                    unsigned int outer_x, outer_y;
                    unsigned int outer_min_x, outer_min_y, outer_max_x, outer_max_y;
                    unsigned char outer_side;
                    unsigned char outer_c, outer_co;

                    switch (outer_type) {
                    case COLLISION_BULLET:
                        outer_side = bullet.side[outer];
                        outer_x = (unsigned int)WORD1(bullet.tx[outer]);
                        outer_y = (unsigned int)WORD1(bullet.ty[outer]);
                        outer_c = bullet.sprite[outer]; // Which sprite is it in the cache...
                        break;
                    case COLLISION_PLAYER:
                        outer_side = SIDE_PLAYER;
                        outer_x = (unsigned int)WORD1(player.tx[outer]);
                        outer_y = (unsigned int)WORD1(player.ty[outer]);
                        outer_c = player.sprite[outer]; // Which sprite is it in the cache...
                        break;
                    case COLLISION_ENEMY:
                        outer_side = SIDE_ENEMY;
                        outer_x = (unsigned int)WORD1(enemy.tx[outer]);
                        outer_y = (unsigned int)WORD1(enemy.ty[outer]);
                        outer_c = enemy.sprite[outer]; // Which sprite is it in the cache...
                        break;
                    case COLLISION_TOWER:
                        outer_side = towers.side[outer];
                        outer_x = (unsigned int)towers.tx[outer];
                        outer_y = (unsigned int)towers.ty[outer];
                        outer_c = towers.sprite[outer]; // Which sprite is it in the cache...
                        break;
                    }

                    outer_co = outer_c * 16;
                    outer_min_x = outer_x + sprite_cache.aabb[outer_co];
                    outer_min_y = outer_y + sprite_cache.aabb[outer_co + 1];
                    outer_max_x = outer_x + sprite_cache.aabb[outer_co + 2];
                    outer_max_y = outer_y + sprite_cache.aabb[outer_co + 3];

                    while (ht_index_inner) {

                        unsigned char inner = (unsigned char)ht_get_data(ht_index_inner);
                        unsigned char inner_type = inner & COLLISION_MASK;
                        inner = inner & ~COLLISION_MASK;

                        unsigned int inner_x, inner_y;
                        unsigned int inner_min_x, inner_min_y, inner_max_x, inner_max_y;
                        unsigned char inner_side;
                        unsigned char inner_c, inner_co;

                        switch (inner_type) {
                        case COLLISION_BULLET:
                            inner_side = bullet.side[inner];
                            inner_x = (unsigned int)WORD1(bullet.tx[inner]);
                            inner_y = (unsigned int)WORD1(bullet.ty[inner]);
                            inner_c = bullet.sprite[inner]; // Which sprite is it in the cache...
                            break;
                        case COLLISION_PLAYER:
                            inner_side = SIDE_PLAYER;
                            inner_x = (unsigned int)WORD1(player.tx[inner]);
                            inner_y = (unsigned int)WORD1(player.ty[inner]);
                            inner_c = player.sprite[inner]; // Which sprite is it in the cache...
                            break;
                        case COLLISION_ENEMY:
                            inner_side = SIDE_ENEMY;
                            inner_x = (unsigned int)WORD1(enemy.tx[inner]);
                            inner_y = (unsigned int)WORD1(enemy.ty[inner]);
                            inner_c = enemy.sprite[inner]; // Which sprite is it in the cache...
                            break;
                        case COLLISION_TOWER:
                            inner_side = towers.side[inner];
                            inner_x = (unsigned int)towers.tx[inner];
                            inner_y = (unsigned int)towers.ty[inner];
                            inner_c = towers.sprite[inner]; // Which sprite is it in the cache...
                            break;
                        }

                        inner_co = inner_c * 16;
                        inner_min_x = inner_x + sprite_cache.aabb[inner_co];
                        inner_min_y = inner_y + sprite_cache.aabb[inner_co + 1];
                        inner_max_x = inner_x + sprite_cache.aabb[inner_co + 2];
                        inner_max_y = inner_y + sprite_cache.aabb[inner_co + 3];

                        // Now comes the collision test!

#ifdef __DEBUG_COLLISION
                        printf("inner_x=%04u, inner_y=%04u\n", inner_x, inner_y);
                        printf("outer_x=%04u, outer_y=%04u\n", outer_x, outer_y);
                        printf("os=%u, is=%u, ", outer_side, inner_side);
                        printf("outer_type=%02x, inner_type=%02x\n", outer_type, inner_type);
#endif

                        if (outer_side != inner_side) {

#ifdef __DEBUG_COLLISION
                            printf("outer_min_x=%04x, inner_min_x=%04x \n", outer_min_x, inner_min_x);
                            printf("outer_min_y=%04x, inner_min_y=%04x \n", outer_min_y, inner_min_y);
                            printf("outer_max_x=%04x, inner_max_x=%04x \n", outer_max_x, inner_max_x);
                            printf("outer_max_y=%04x, inner_max_y=%04x \n", outer_max_y, inner_max_y);
#endif

                            if (inner_min_x > outer_max_x ||
                                inner_min_y > outer_max_y ||
                                inner_max_x < outer_min_x ||
                                inner_max_y < outer_min_y) {
                                // no collision
                            } else {

                                // Collision happened
                                if (outer_side == SIDE_ENEMY) {
                                    switch (outer_type) {
                                    case COLLISION_BULLET:
#ifdef __DEBUG_COLLISION
                                        printf(", bullet %u -> ", outer);
#endif
                                        if (inner_type == COLLISION_PLAYER) {
#ifdef __DEBUG_COLLISION
                                            printf("player %u", inner);
#endif
                                            bullet_remove(outer);
                                            player_remove(inner, outer);
                                        }
                                        break;

                                    case COLLISION_ENEMY:
#ifdef __DEBUG_COLLISION
                                        printf(", enemy %u -> ", outer);
#endif
                                        if (inner_type == COLLISION_BULLET) {
#ifdef __DEBUG_COLLISION
                                            printf("bullet %u", inner);
#endif
                                            bullet_remove(inner);
                                            stage_enemy_hit(enemy.wave[outer], outer, inner);
                                        }
                                        if (inner_type == COLLISION_PLAYER) {
#ifdef __DEBUG_COLLISION
                                            printf("player %u", inner);
#endif
                                            stage_enemy_hit(enemy.wave[outer], outer, inner);
                                            player_remove(inner, outer);
                                        }
                                        break;
                                    case COLLISION_TOWER:
#ifdef __DEBUG_COLLISION
                                        printf(", tower %u -> ", outer);
#endif
                                        if (inner_type == COLLISION_BULLET) {
#ifdef __DEBUG_COLLISION
                                            printf("bullet %u", inner);
#endif
                                            bullet_remove(inner);
                                            tower_hit(outer, inner);
                                        }
                                        break;
                                    }
                                } else {
                                    // Friendly
                                    switch (outer_type) {
                                    case COLLISION_BULLET:
#ifdef __DEBUG_COLLISION
                                        printf(", bullet %u -> ", outer);
#endif
                                        if (inner_type == COLLISION_ENEMY) {
#ifdef __DEBUG_COLLISION
                                            printf("enemy %u", inner);
#endif
                                            bullet_remove(outer);
                                            stage_enemy_hit(enemy.wave[outer], outer, inner);
                                        }
                                        if (inner_type == COLLISION_TOWER) {
#ifdef __DEBUG_COLLISION
                                            printf("tower %u", inner);
#endif
                                            bullet_remove(outer);
                                            tower_hit(inner, outer);
                                        }
                                        break;

                                    case COLLISION_PLAYER:
#ifdef __DEBUG_COLLISION
                                        printf(", enemy %u -> ", outer);
#endif
                                        if (inner_type == COLLISION_ENEMY) {
#ifdef __DEBUG_COLLISION
                                            printf("bullet %u", inner);
#endif
                                            stage_enemy_hit(enemy.wave[outer], outer, inner);
                                            player_remove(inner, outer);
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
    bank_pull_bram();
}

#pragma var_model(mem)
