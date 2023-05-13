#pragma once

#include "equinoxe-animate-types.h"
#include "../src/equinoxe-flightengine-types.h"

extern __stackcall __library(animate) void animate_init();
extern __stackcall __library(animate) unsigned char animate_add(char count, char state, char loop, char speed, signed char direction, char reverse);
extern __stackcall __library(animate) unsigned char animate_del(unsigned char a);
extern __stackcall __library(animate) unsigned char animate_is_waiting(unsigned char a);
extern __stackcall __library(animate) unsigned char animate_get_transition(unsigned char a);
extern __stackcall __library(animate) unsigned char animate_get_image(unsigned char a);
extern __stackcall __library(animate) void animate_logic(unsigned char a);
extern __stackcall __library(animate) void animate_player(unsigned char a, signed int x, signed int px);
extern __stackcall __library(animate) void animate_tower(unsigned char a);
