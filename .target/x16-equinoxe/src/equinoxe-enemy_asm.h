extern __varcall __asm_import("equinoxe-enemy") __bank( cx16_ram, 8 ) __zp_reserve( 55,56,57,46,49,50,51,52 ) char enemy_add(__mem() char w, __mem() char sprite_enemy);
extern __varcall __asm_import("equinoxe-enemy") __bank( cx16_ram, 8 ) void enemy_move(__mem() char e, __mem() unsigned int moving, __mem() char turn, __mem() char speed);
extern __varcall __asm_import("equinoxe-enemy") __bank( cx16_ram, 8 ) void enemy_arc(__mem() char e, __mem() char turn, __mem() char radius, __mem() char speed);
extern __varcall __asm_import("equinoxe-enemy") __bank( cx16_ram, 8 ) __zp_reserve( 34,46,35,58,47,37,59,48,50,51 ) void enemy_logic();
extern __varcall __asm_import("equinoxe-enemy") __bank( cx16_ram, 8 ) __mem() char enemy_get_wave(__mem() char e);
extern __phicall __asm_import("equinoxe-enemy") void __equinoxe_enemy_start();
