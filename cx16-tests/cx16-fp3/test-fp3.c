
#pragma var_model(mem)

#include <conio.h>
#include <printf.h>
#include <division.h>
#include <multiply.h>
#include "equinoxe-math.h"





typedef struct _entity {
    byte active;
    byte SpriteType;
    byte state_behaviour;
    byte state_animation;
    byte wait_animation;
    byte speed_animation;
    byte health;
    byte gun;
    byte strength;
    byte reload;
    byte moved;
    byte side;
    byte firegun;
    unsigned int flight;
    unsigned char move;
    unsigned char step;
    unsigned char angle;
    unsigned char baseangle;
    unsigned char radius;
    unsigned char delay;
    signed char turn;
    unsigned char speed;

    FP3 tx;
    FP3 ty;
    FP3 tdx;
    FP3 tdy;
} Enemy;


void AddEnemy(Enemy* enemy, char t, signed int x, signed int y) {

	enemy->health = 1;
	fp3_set(&enemy->tx, x, 0);
	fp3_set(&enemy->ty, y, 0);
	enemy->speed_animation = 4;
	enemy->wait_animation = enemy->speed_animation;
	enemy->state_animation = 12;
	enemy->moved = 2;
}


void MoveEnemy( Enemy* enemy, unsigned int flight, signed char turn, unsigned char speed) {
	enemy->move = 1;
	enemy->flight = flight;
	// enemy->flight >>= speed;
	enemy->angle = enemy->angle + turn;
	enemy->speed = speed;
}

void ArcEnemy( Enemy* enemy, signed char turn, unsigned char radius, unsigned char speed) {
	enemy->move = 2;
	enemy->turn = turn;
	enemy->radius = radius;
	enemy->delay = 0;
	enemy->flight = mul8u(abs_u8((unsigned char)turn), radius);
	enemy->baseangle = enemy->angle;
	enemy->speed = speed;
}


void LogicEnemies(int f, Enemy* enemy) {

    // signed int x = enemy->x;
    // signed int y = enemy->y;
    // signed char fx = enemy->fx;
    // signed char fy = enemy->fy;
    // signed char dx = enemy->dx;
    // signed char dy = enemy->dy;


    if(!enemy->flight) {
        switch(enemy->step) {
        case 0:
            // MoveEnemy(enemy, 320, 16, 5);
            MoveEnemy(enemy, 10, 16, 0);
            enemy->step++;
            break;
        case 1:
            // ArcEnemy(enemy, -64, 12, 4);
            ArcEnemy(enemy, -64, 12, 2);
            enemy->step++;
            break;
        case 2:
            // MoveEnemy(enemy, 80, 0, 4);
            MoveEnemy(enemy, 80, 12, 2);
            enemy->step++;
            break;
        // case 3:
        //     // ArcEnemy(enemy, 64, 9, 4);
        //     ArcEnemy(enemy, 64, 9, 0);
        //     enemy->step++;
        //     break;
        // case 4:
        //     // ArcEnemy(enemy, 8, 12, 3);
        //     ArcEnemy(enemy, 8, 12, 0);
        //     enemy->step++;
        //     break;
        // case 5:
        //     // MoveEnemy(enemy, 160, 0, 3);
        //     MoveEnemy(enemy, 160, 0, 0);
        //     enemy->step++;
        //     break;
        // case 6:
        //     // ArcEnemy(enemy, 16, 12, 3);
        //     ArcEnemy(enemy, 16, 12, 3);
        //     enemy->step++;
        //     break;
        // case 7:
        //     // ArcEnemy(enemy, 16, 12, 2);
        //     ArcEnemy(enemy, 16, 12, 3);
        //     enemy->step++;
        //     break;
        // case 8:
        //     // MoveEnemy(enemy, 80, 0, 2);
        //     MoveEnemy(enemy, 80, 0, 3);
        //     enemy->step++;
        //     break;
        // case 9:
        //     // ArcEnemy(enemy, 24, 12, 4);
        //     ArcEnemy(enemy, 24, 12, 3);
        //     enemy->step++;
        //     break;
        // case 10:
        //     // MoveEnemy(enemy, 160, 0, 4);
        //     MoveEnemy(enemy, 160, 0, 3);
        //     enemy->step++;
        //     break;
        // case 11:
        //     enemy_handle = RemoveEnemy(enemy_handle);
        }
    }

    if(enemy->flight) {
        enemy->flight--;
        if(enemy->move == 1) {
            vecx(&enemy->tdx, enemy->angle, enemy->speed);
            vecy(&enemy->tdy, enemy->angle, enemy->speed);
        }

        if(enemy->move == 2) {
            // Calculate current angle based on flight from x,y and angle startpoint.
            if(!enemy->delay) {
                enemy->angle += sgn_u8((unsigned char)enemy->turn);
                enemy->angle %= 64;
                enemy->delay = enemy->radius;
                vecx(&enemy->tdx, enemy->angle, enemy->speed);
                vecy(&enemy->tdy, enemy->angle, enemy->speed);
            }
            enemy->delay--;
        }
    } else {
        enemy->move = 0;
    }

    fp3_add(&enemy->tx, &enemy->tdx);
    fp3_add(&enemy->ty, &enemy->tdy);


    gotoxy(0, 23);
    printf("step=%u, f=%i,", enemy->step, f);
    printf(", move=%u\n", enemy->move);
    printf("tx=%06i, ty=%06i, tdx= %06i, tdy=%06i", enemy->tx.i, enemy->ty.i, enemy->tdx.f, enemy->tdy.f);

    while(!getin());

    if (enemy->reload > 0) {
        enemy->reload--;
    }

    if (!enemy->wait_animation--) {
        enemy->wait_animation = enemy->speed_animation;
        if(!enemy->state_animation--)
        enemy->state_animation += 12;
    }

}



void main() {

    Enemy enemy;

    AddEnemy(&enemy, 1, 0, 0);

    clrscr();
    gotoxy(0,0);
    printf("test math");

    for(int f=0; f<2000; f++) {
        LogicEnemies(f, &enemy);
    }


}
