extern __varcall __lib_import("equinoxe-enemy") __bank( cx16_ram, 8 ) char enemy_add(__mem() char w, __mem() char sprite_enemy);
extern __varcall __lib_import("equinoxe-enemy") __bank( cx16_ram, 8 ) void enemy_logic();
extern __varcall __lib_import("equinoxe-enemy") __bank( cx16_ram, 8 ) __mem() char enemy_get_wave(__mem() char e);
extern __phicall __lib_import("equinoxe-enemy") void __equinoxe_enemy_start();
